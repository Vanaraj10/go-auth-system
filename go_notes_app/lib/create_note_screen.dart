import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_notes_app/main.dart';
import 'package:http/http.dart' as http;

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<void> addNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      setState(() {
        errorMessage = "Title and content cannot be empty.";
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final token = storage.read("jwt_token");
    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = "You must be logged in to add a note.";
      });
      return;
    }
    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/notes",
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'content': content}),
    );
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        errorMessage = "Failed to add note. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Note"),
        actions: [IconButton(icon: Icon(Icons.save,color: Colors.green,size: 35,), onPressed: addNote)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(fontSize: 30),
              decoration: InputDecoration(
                hintText: "Enter note title",
                
                hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 400,
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Enter note content",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                  border: InputBorder.none
                ),
              ),
            ),
            if (isLoading) 
              Padding(padding: EdgeInsets.only(top: 10),
              child: CircularProgressIndicator.adaptive(strokeWidth: 8.0,),) 
          ],
        ),
        ),
    );
  }
}
