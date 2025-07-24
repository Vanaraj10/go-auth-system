import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_notes_app/main.dart';
import 'package:http/http.dart' as http;

class EditNoteScreen extends StatefulWidget {
  final int noteId;
  final String initialTitle;
  final String initialContent;
  const EditNoteScreen({
    super.key,
    required this.noteId,
    required this.initialTitle,
    required this.initialContent,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);
  }

  Future<void> updateNote() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final token = storage.read("jwt_token");

    if(titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and content cannot be empty.")),
      );
      return;
    }

    if (token == null ) {
      setState(() {
        isLoading = false;
        errorMessage = "You must be logged in to edit a note.";
      });
      return;
    }
    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/note/update?id=${widget.noteId}",
    );
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
      }),
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        errorMessage = "Failed to update note: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.green),
            onPressed: updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  hintText: "Edit note title",
          
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Edit note content",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
