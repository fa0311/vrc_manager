import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp getMaterialApp(home, theme) {
  return MaterialApp(
      title: 'VRChat Mobile Application',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''),
        Locale('en', ''),
      ],
      theme: ThemeData(
        brightness: theme,
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16)),
      ),
      home: home);
}
