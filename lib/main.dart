import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import './config/env.dart';
import './views/auth_page.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures proper async initialization
  runApp(const QuickTaskApp());
}

class QuickTaskApp extends StatelessWidget {
  const QuickTaskApp({super.key});

  Future<bool> _initializeParse() async {
    try {
      const keyApplicationId = appId;
      const keyClientKey = clientKey;
      const keyParseServerUrl = serverUrl;

      // Check for missing configuration
      if (keyApplicationId.isEmpty ||
          keyClientKey.isEmpty ||
          keyParseServerUrl.isEmpty) {
        throw Exception('Parse server configuration is missing or invalid.');
      }

      final response = await Parse().initialize(
        keyApplicationId,
        keyParseServerUrl,
        clientKey: keyClientKey,
      );

      if (!response.hasParseBeenInitialized()) {
        throw Exception('Parse server initialization failed.');
      }

      return true;
    } catch (e) {
      debugPrint('Error during Parse initialization: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _initializeParse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == false) {
            return const ErrorScreen();
          }

          return AuthScreen();
        },
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Initialization Error")),
      body: Center(
        child: Text(
          "Failed to connect to the server. Please check your configuration and try again.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
