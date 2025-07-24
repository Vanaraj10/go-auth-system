import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_notes_app/create_note_screen.dart';
import 'package:go_notes_app/edit_note_screen.dart';
import 'package:go_notes_app/main.dart';
import 'package:go_notes_app/welcome_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List notes = [];
  bool isLoading = true;

  final token = storage.read('jwt_token');

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> deleteNote(int noteId) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/note/delete?id=$noteId",
    );
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      setState(() {
        notes.removeWhere((note) => note['id'] == noteId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete note. Please try again.")),
      );
    }
  }

  Future<void> fetchNotes() async {
    setState(() => isLoading = true);
    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/get-notes",
    );
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    List newNotes = [];
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) newNotes = decoded;
    }
    setState(() {
      notes = newNotes;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Icon(Icons.star, size: 35, color: Colors.yellow),
        title: Text("StarNotes"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              storage.remove('jwt_token');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? const  Center(child: CircularProgressIndicator())
            : notes.isEmpty
            ?const Center(
                child: Text("No Notes Found", style: TextStyle(fontSize: 30)),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onLongPress: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            title: Text("Delete Note"),
                            content: Text(
                              "Are you sure you want to delete this note?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        await deleteNote(note['id']);
                      }
                    },
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditNoteScreen(
                              noteId: note['id'],
                              initialTitle: note['title'] ?? '',
                              initialContent: note['content'] ?? '',
                            );
                          },
                        ),
                      );
                      if (updated == true) {
                        fetchNotes();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['title'] ?? 'No Title',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                         const  SizedBox(height: 5),
                          Text(
                            note['content'].toString().length > 50
                                ? note['content'].toString().substring(0, 50) +
                                      '...'
                                : note['content'].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CreateNoteScreen();
              },
            ),
          );
          if (created == true) {
            fetchNotes(); // Refresh notes after creating a new one
          }
        },
        child:const  Icon(Icons.add),
      ),
    );
  }
}
