import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'config/env.dart';
import 'views/auth_page.dart';

void main() async {
  const keyApplicationId = appId;
  const keyClientKey = clientKey;
  const keyParseServerUrl = serverUrl;

  await Parse()
      .initialize(keyApplicationId, keyParseServerUrl, clientKey: keyClientKey);

  runApp(const QuickTaskApp());
}

class QuickTaskApp extends StatelessWidget {
  const QuickTaskApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthScreen(),
    );
  }
}
