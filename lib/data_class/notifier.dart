// Flutter imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/enum.dart';

class ThemeBrightnessNotifier extends StateNotifier<ThemeBrightness> {
  ThemeBrightnessNotifier() : super(ThemeBrightness.light);
  static const String key = "theme_brightness";

  Future get() async {
    state = ThemeBrightness.values.byName(await getStorage(key) ?? "");
  }

  Future set(ThemeBrightness set) async {
    await setStorage(key, (state = set).name);
  }
}

class LanguageCodeNotifier extends StateNotifier<LanguageCode> {
  LanguageCodeNotifier() : super(LanguageCode.en);
  static const String key = "language_code";

  Future get() async {
    state = LanguageCode.values.byName(await getStorage(key) ?? "");
  }

  Future set(LanguageCode set) async {
    await setStorage(key, (state = set).name);
  }
}
