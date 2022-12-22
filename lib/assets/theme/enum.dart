// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/assets/theme/true_black.dart';

enum ThemeBrightness {
  light,
  dark,
  black,
  trueBlack;

  String toLocalization(BuildContext context) {
    switch (this) {
      case ThemeBrightness.light:
        return AppLocalizations.of(context)!.lightTheme;
      case ThemeBrightness.dark:
        return AppLocalizations.of(context)!.darkTheme;
      case ThemeBrightness.black:
        return AppLocalizations.of(context)!.blackTheme;
      case ThemeBrightness.trueBlack:
        return AppLocalizations.of(context)!.trueBlackTheme;
    }
  }

  ThemeData toTheme() {
    switch (this) {
      case ThemeBrightness.light:
        return ThemeData(brightness: Brightness.light);
      case ThemeBrightness.dark:
        return ThemeData(brightness: Brightness.dark);
      case ThemeBrightness.black:
        return blackTheme();
      case ThemeBrightness.trueBlack:
        return trueBlackTheme();
    }
  }
}
