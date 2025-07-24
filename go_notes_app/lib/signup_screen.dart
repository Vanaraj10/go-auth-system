import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_notes_app/welcome_screen.dart';
import 'package:http/http.dart' as http;

final storage = GetStorage();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscureText = true;

  Future<void> _signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields.";
      });
      return;
    }
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    final url = Uri.parse(
      "https://go-auth-system-production.up.railway.app/register",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        isLoading = false;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text("Email Verification"),
              content: Text(
                "A verification email has been sent. Please verify your email",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          errorMessage = "Failed to sign up. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Sign Up")),
      body:  Center(
        child:  Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               const SizedBox(height: 100.0),
              const Text(
                "Welcome",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Create your account",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 35, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  hint: Text("Email Address"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password, color: Colors.blueAccent),
                  hint: Text("Password"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }, icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blueAccent,
                  ))
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              if (errorMessage != null)
                Text(
                  textAlign: TextAlign.center,
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                onPressed: _signup,
                child: Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),
              if (isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: const CircularProgressIndicator.adaptive(strokeWidth: 8.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
