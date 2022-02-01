import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VRChat Mobile Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VRChatMobileHome(title: 'VRChat Mobile Application by fa0311'),
    );
  }
}
