import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import './task_list.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _errorText = ValueNotifier<String>("");

  bool _isLoading = false;

  // Validate email and password
  bool _validateInputs() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _errorText.value = 'Please enter a valid email address.';
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      _errorText.value = 'Password must be at least 6 characters long.';
      return false;
    }

    _errorText.value = ''; // Clear error text if inputs are valid
    return true;
  }

  // Handle Authentication (Login / Sign Up)
  Future<void> _handleAuth() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Try logging in first
      final loginError = await _authService.login(email, password);

      if (loginError == null) {
        // Navigate to Task List screen if login succeeds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen()),
        );
        return;
      }

      // If login fails, try signing up
      final signUpError = await _authService.signUp(email, password);

      if (signUpError == null) {
        // Navigate to Task List screen if sign-up succeeds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskListScreen()),
        );
      } else {
        _errorText.value = signUpError; // Show sign-up error
      }
    } catch (e) {
      _errorText.value = 'An unexpected error occurred: $e';
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login / Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Password Input
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 16),

            // Error Message
            ValueListenableBuilder<String>(
              valueListenable: _errorText,
              builder: (context, error, child) {
                return error.isEmpty
                    ? SizedBox.shrink()
                    : Text(error, style: TextStyle(color: Colors.red));
              },
            ),
            SizedBox(height: 16),

            // Authentication Button
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleAuth,
                    child: Text("Login / Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}
