// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/l10n/code.dart';

class ThemeBrightnessNotifier extends StateNotifier<ThemeBrightness> {
  late String key;
  ThemeBrightnessNotifier(this.key) : super(ThemeBrightness.light) {
    getStorage(key).then((value) => state = ThemeBrightness.values.byName(value ?? state.name));
  }

  Future set(ThemeBrightness set) async {
    await setStorage(key, (state = set).name);
  }
}

class LanguageCodeNotifier extends StateNotifier<LanguageCode> {
  late String key;
  LanguageCodeNotifier(this.key) : super(LanguageCode.en) {
    getStorage(key).then((value) => state = LanguageCode.values.byName(value ?? state.name));
  }

  Future set(LanguageCode set) async {
    await setStorage(key, (state = set).name);
  }
}

class BooleanNotifier extends StateNotifier<bool> {
  late String key;
  BooleanNotifier(this.key) : super(false) {
    getStorage(key).then((value) => state = value == "true");
  }

  Future set(bool set) async {
    await setStorage(key, (state = set).toString());
  }
}
