// Flutter imports:
import 'package:flutter/material.dart';

ThemeData blackTheme() {
  Color black = const Color.fromARGB(255, 0, 0, 0);
  Color grey = const Color.fromARGB(255, 10, 10, 10);
  return ThemeData(
    brightness: Brightness.dark,
    backgroundColor: black,
    bottomAppBarColor: black,
    canvasColor: grey,
    cardColor: grey,
    dialogBackgroundColor: black,
    primaryColor: black,
    primaryColorDark: black,
    primaryColorLight: black,
    scaffoldBackgroundColor: black,
    secondaryHeaderColor: black,
  );
}

ThemeData trueBlackTheme() {
  Color black = const Color.fromARGB(255, 0, 0, 0);
  return ThemeData(
    brightness: Brightness.dark,
    backgroundColor: black,
    bottomAppBarColor: black,
    canvasColor: black,
    cardColor: black,
    dialogBackgroundColor: black,
    highlightColor: const Color.fromARGB(150, 20, 20, 20),
    primaryColor: black,
    primaryColorDark: black,
    primaryColorLight: black,
    scaffoldBackgroundColor: black,
    secondaryHeaderColor: black,
    splashColor: const Color.fromARGB(255, 20, 20, 20),
  );
}
