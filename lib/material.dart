// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp getMaterialApp(home, String theme, Locale locale) {
  Map themeMap = {
    "dark": ThemeData(
      brightness: Brightness.dark,
      textTheme: const TextTheme(
        bodyText2: TextStyle(fontSize: 16),
      ),
      primarySwatch: Colors.grey,
    ),
    "light": ThemeData(
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyText2: TextStyle(fontSize: 16),
      ),
      primarySwatch: Colors.blue,
    ),
  };

  return MaterialApp(
    title: 'VRChat Mobile Client',
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en', ''),
      Locale('ja', ''),
      Locale('es', ''),
      Locale('pt', ''),
      Locale('ru', ''),
      Locale('th', ''),
      Locale('zh', ''),
    ],
    locale: locale,
    theme: themeMap[theme],
    darkTheme: themeMap["dark"],
    home: home,
  );
}
