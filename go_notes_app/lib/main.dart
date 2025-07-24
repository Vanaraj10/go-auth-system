import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_notes_app/login_screen.dart';
import 'package:go_notes_app/signup_screen.dart';
import 'package:go_notes_app/welcome_screen.dart';
import 'home_screen.dart';

final storage = GetStorage();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const SignupScreen(), // Assuming you have a RegisterScreen
        '/login': (context) => const LoginScreen(), // Assuming you have a LoginScreen
      },
      debugShowCheckedModeBanner: false,
      title: "StarNotes",
      theme: ThemeData(brightness: Brightness.dark),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool> hasToken() async {
    final token = storage.read('jwt_token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
