import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_notes_app/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true;
    });
    final token = storage.read('jwt_token');
    if (token == null) {
      setState(() {
        notes = [];
        isLoading = false;
      });
      return;
    }
    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/get-notes",
    );
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      setState(() {
        notes = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        notes = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("StarNotes"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => fetchNotes()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : notes.isEmpty
            ? Center(child: Text("No Notes Found"))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () {
                      print("Tapped on note: ${note['id']}");
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
                          SizedBox(height: 5),
                          Text(
                            note['content'].toString().length > 50
                                ? note['content'].toString().substring(0, 50) + '...'
                                : note['content'].toString(),
                            style: TextStyle(fontSize: 18,color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
