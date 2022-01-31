import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VRChat Mobile Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VRChatMobile(title: 'VRChat Mobile Application by fa0311'),
    );
  }
}
