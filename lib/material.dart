import 'package:flutter/material.dart';

MaterialApp getMaterialApp(home, theme) {
  return MaterialApp(
      title: 'VRChat Mobile Application',
      theme: ThemeData(
        brightness: theme,
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16)),
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: home);
}
