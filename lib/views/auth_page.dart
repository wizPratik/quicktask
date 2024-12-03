import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'task_list.dart';
import 'package:quicktask/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _errorText = ValueNotifier<String>("");

  Future<void> handleAuth() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Try logging in first
    final loginError = await _authService.login(email, password);

    if (loginError == null) {
      // If login is successful, navigate to the Task List screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    } else {
      // If login failed (likely because user does not exist), try signing up
      final signUpError = await _authService.signUp(email, password);

      if (signUpError == null) {
        // If sign-up is successful, navigate to the Task List screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen()),
        );
      } else {
        // If both login and sign-up fail, show the error
        _errorText.value = signUpError;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login / Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ValueListenableBuilder<String>(
              valueListenable: _errorText,
              builder: (context, error, child) {
                return Text(error, style: TextStyle(color: Colors.red));
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: handleAuth, // Trigger login or sign-up
              child: Text("Login / Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
