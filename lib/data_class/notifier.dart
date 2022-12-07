// Flutter imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/enum.dart';

class ThemeBrightnessNotifier extends StateNotifier<ThemeBrightness> {
  late String key;
  ThemeBrightnessNotifier(this.key) : super(ThemeBrightness.light);

  Future get() async {
    String? storage = await getStorage(key);
    if (storage != null) {
      state = ThemeBrightness.values.byName(storage);
    }
  }

  Future set(ThemeBrightness set) async {
    await setStorage(key, (state = set).name);
  }
}

class LanguageCodeNotifier extends StateNotifier<LanguageCode> {
  late String key;
  LanguageCodeNotifier(this.key) : super(LanguageCode.en);

  Future get() async {
    String? storage = await getStorage(key);
    if (storage != null) {
      state = LanguageCode.values.byName(storage);
    }
  }

  Future set(LanguageCode set) async {
    await setStorage(key, (state = set).name);
  }
}

class BooleanNotifier extends StateNotifier<bool> {
  late String key;
  BooleanNotifier(this.key) : super(false);

  Future get() async {
    state = await getStorage(key) == "true";
  }

  Future set(bool set) async {
    await setStorage(key, (state = set).toString());
  }
}
