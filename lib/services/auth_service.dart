import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthService {
  // Generic method to handle responses
  String? _handleResponse(ParseResponse response) {
    if (response.success) {
      return null;
    } else {
      return response.error?.message ?? 'An unknown error occurred';
    }
  }

  // Login Method
  Future<String?> login(String email, String password) async {
    try {
      final user = ParseUser(email, password, null);
      final response = await user.login();
      return _handleResponse(response);
    } catch (e) {
      return 'An error occurred during login: $e';
    }
  }

  // Sign-Up Method
  Future<String?> signUp(String email, String password) async {
    try {
      final user = ParseUser(email, password, email);
      final response = await user.signUp();
      return _handleResponse(response);
    } catch (e) {
      return 'An error occurred during sign-up: $e';
    }
  }

  // Logout Method
  Future<String?> logout() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user == null) {
        return 'No user is currently logged in';
      }
      final response = await user.logout();
      return _handleResponse(response);
    } catch (e) {
      return 'An error occurred during logout: $e';
    }
  }

  // Password Reset
  Future<String?> resetPassword(String email) async {
    try {
      final response =
          await ParseUser(null, null, email).requestPasswordReset();
      return _handleResponse(response);
    } catch (e) {
      return 'An error occurred during password reset: $e';
    }
  }

  // Get Current User
  Future<ParseUser?> getCurrentUser() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      return user; // Returns null if no user is logged in
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }
}
