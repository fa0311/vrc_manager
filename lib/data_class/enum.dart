// Project imports:
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/assets/theme/true_black.dart';

enum ThemeBrightness {
  light,
  dark,
  trueBlack,
  auto;

  String toLocalization(BuildContext context) {
    switch (this) {
      case ThemeBrightness.light:
        return AppLocalizations.of(context)!.lightTheme;
      case ThemeBrightness.dark:
        return AppLocalizations.of(context)!.darkTheme;
      case ThemeBrightness.trueBlack:
        return AppLocalizations.of(context)!.trueBlackTheme;
      case ThemeBrightness.auto:
        return AppLocalizations.of(context)!.deviceTheme;
    }
  }

  toTheme() {
    switch (this) {
      case ThemeBrightness.light:
        return ThemeData(brightness: Brightness.light);
      case ThemeBrightness.dark:
        return ThemeData(brightness: Brightness.dark);
      case ThemeBrightness.trueBlack:
        return ThemeData(brightness: Brightness.dark);
      case ThemeBrightness.auto:
        return ThemeData(brightness: Brightness.light);
    }
  }

  toDarkTheme() {
    switch (this) {
      case ThemeBrightness.light:
        return ThemeData(brightness: Brightness.light);
      case ThemeBrightness.dark:
        return ThemeData(brightness: Brightness.dark);
      case ThemeBrightness.trueBlack:
        return trueBlackTheme;
      case ThemeBrightness.auto:
        return ThemeData(brightness: Brightness.dark);
    }
  }
}

enum LanguageCode {
// cSpell:disable
  en("English"),
  ja("日本語"),
  es("español"),
  pt("Português"),
  ru("русский"),
  th("ไทย"),
  zh("简体中文");
// cSpell:enable

  final String text;
  const LanguageCode(this.text);
}
