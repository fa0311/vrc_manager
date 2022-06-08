// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp getMaterialApp(home, Brightness theme, Locale locale) {
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
      locale: locale,
      theme: ThemeData(
        brightness: theme,
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 16)),
      ),
      home: home);
}
