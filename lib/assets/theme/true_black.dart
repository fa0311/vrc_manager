// Flutter imports:
import 'package:flutter/material.dart';

ThemeData blackTheme() {
  Color black = const Color.fromARGB(255, 0, 0, 0);
  Color grey = const Color.fromARGB(255, 20, 20, 20);
  return ThemeData(
    brightness: Brightness.dark,
    canvasColor: grey,
    cardColor: grey,
    primaryColor: black,
    primaryColorDark: black,
    primaryColorLight: black,
    scaffoldBackgroundColor: black,
    secondaryHeaderColor: black,
    appBarTheme: AppBarTheme(backgroundColor: grey),
    bottomAppBarTheme: BottomAppBarThemeData(color: black),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey, brightness: Brightness.dark).copyWith(surface: black),
    dialogTheme: DialogThemeData(backgroundColor: black),
  );
}

ThemeData trueBlackTheme() {
  Color black = const Color.fromARGB(255, 0, 0, 0);
  return ThemeData(
    brightness: Brightness.dark,
    canvasColor: black,
    cardColor: black,
    highlightColor: const Color.fromARGB(150, 20, 20, 20),
    primaryColor: black,
    primaryColorDark: black,
    primaryColorLight: black,
    scaffoldBackgroundColor: black,
    secondaryHeaderColor: black,
    splashColor: const Color.fromARGB(255, 20, 20, 20),
    appBarTheme: AppBarTheme(backgroundColor: black),
    bottomAppBarTheme: BottomAppBarThemeData(color: black),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey, brightness: Brightness.dark).copyWith(surface: black),
    dialogTheme: DialogThemeData(backgroundColor: black),
  );
}

ThemeData highContrastLightTheme() {
  return ThemeData(brightness: Brightness.light, colorScheme: const ColorScheme.highContrastLight());
}

ThemeData highContrastDarkTheme() {
  return ThemeData(brightness: Brightness.dark, colorScheme: const ColorScheme.highContrastDark());
}
