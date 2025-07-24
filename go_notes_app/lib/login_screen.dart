import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_notes_app/main.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscureText = true;
  
  Future<void> _login() async {
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
      "https://go-auth-system-production.up.railway.app/login",
    );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        storage.write('jwt_token', token);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>const HomeScreen()),
        );
      } else {
        setState(() {
          errorMessage = "Email not verified or invalid credentials.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    }
  }

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Login")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100.0),
              const Text(
                "Hey",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Welcome back",
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
                obscureText: _obscureText,
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
                onPressed: _login,
                child: Text("Login", style: TextStyle(fontSize: 18)),
              ),
              if(isLoading == true)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child:const  CircularProgressIndicator.adaptive(strokeWidth: 8.0,),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}