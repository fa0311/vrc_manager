import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';

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
        brightness: true ? Brightness.dark : Brightness.light,
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16)),
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: const VRChatMobileHome(),
    );
  }
}
