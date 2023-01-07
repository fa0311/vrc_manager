// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/l10n/code.dart';

final accessibilityConfigProvider = ChangeNotifierProvider<AccessibilityConfigNotifier>((ref) => AccessibilityConfigNotifier());

class AccessibilityConfigNotifier extends ChangeNotifier {
  LanguageCode languageCode = LanguageCode.en;
  ThemeBrightness themeBrightness = ThemeBrightness.light;
  ThemeBrightness darkThemeBrightness = ThemeBrightness.dark;
  bool forceExternalBrowser = false;
  bool debugMode = false;

  AccessibilityConfigNotifier() {
    Future.wait([
      getStorage("language_code").then((String? value) => languageCode = LanguageCode.values.byName(value ?? languageCode.name)),
      getStorage("theme_brightness").then((String? value) => themeBrightness = ThemeBrightness.values.byName(value ?? themeBrightness.name)),
      getStorage("dark_theme_brightness").then((String? value) => darkThemeBrightness = ThemeBrightness.values.byName(value ?? darkThemeBrightness.name)),
      getStorage("force_external_browser").then((String? value) => forceExternalBrowser = (value == "true")),
      getStorage("debug_mode").then((String? value) => debugMode = (value == "true")),
    ]).whenComplete(() => notifyListeners());
  }

  Future setLanguageCode(LanguageCode value) async {
    languageCode = value;
    notifyListeners();
    return await setStorage("language_code", value.name);
  }

  Future setThemeBrightness(ThemeBrightness value) async {
    themeBrightness = value;
    notifyListeners();
    return await setStorage("theme_brightness", themeBrightness.name);
  }

  Future setDarkThemeBrightness(ThemeBrightness value) async {
    darkThemeBrightness = value;
    notifyListeners();
    return await setStorage("dark_theme_brightness", darkThemeBrightness.name);
  }

  Future setForceExternalBrowser(bool value) async {
    forceExternalBrowser = value;
    notifyListeners();
    return await setStorage("force_external_browser", forceExternalBrowser ? "true" : "false");
  }

  Future setDebugMode(bool value) async {
    debugMode = value;
    notifyListeners();
    return await setStorage("debug_mode", debugMode ? "true" : "false");
  }
}
