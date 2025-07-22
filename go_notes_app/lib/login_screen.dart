import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Center(
        child: Column(
          children: [
            Text("Login Screen", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}