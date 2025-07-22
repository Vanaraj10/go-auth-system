import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              SizedBox(height: 100.0,),
              Text(
                "Hey",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              Text(
                "Welcome back",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 35, color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email,color: Colors.blueAccent),
                  hint: Text("Email Address"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password, color: Colors.blueAccent,),
                  hint: Text("Password"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
              if (errorMessage != null)
                Text(
                  textAlign: TextAlign.center,
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              SizedBox(height: 15),
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
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text;
                  if (email.isEmpty || password.isEmpty) {
                    setState(() {
                      errorMessage = "Please fill in all fields.";
                    });
                  } else {
                    setState(() {
                      errorMessage = null; // Clear error message
                    });
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Login Pressed"),behavior: SnackBarBehavior.floating,));
                },
                child: Text("Login", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          
        ),
      ),
    );
  }
}