import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  // Login Method
  Future<String?> login(String email, String password) async {
    try {
      final user = ParseUser(email, password, null);
      final ParseResponse response = await user.login();

      if (response.success) {
        return null; // Return null on success, indicating no error
      } else {
        return response.error?.message ??
            'Login failed'; // Return error message if login fails
      }
    } catch (e) {
      return 'An error occurred during login: $e';
    }
  }

  // Sign-Up Method
  Future<String?> signUp(String email, String password) async {
    try {
      final user = ParseUser(email, password, email);
      final ParseResponse response = await user.signUp();

      if (response.success) {
        return null; // Return null on success, indicating no error
      } else {
        return response.error?.message ??
            'Sign-up failed'; // Return error message if sign-up fails
      }
    } catch (e) {
      return 'An error occurred during sign-up: $e';
    }
  }
}
