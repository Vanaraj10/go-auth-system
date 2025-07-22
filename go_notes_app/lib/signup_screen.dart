import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Center(
        child: Column(
          children: [
            Text("Signup Screen", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}