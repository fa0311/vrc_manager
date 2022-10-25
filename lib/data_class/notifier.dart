// Flutter imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/enum.dart';

class ThemeBrightnessNotifier extends StateNotifier<ThemeBrightness> {
  late String key;
  ThemeBrightnessNotifier(key) : super(ThemeBrightness.light);

  Future get() async {
    state = ThemeBrightness.values.byName(await getStorage(key) ?? "");
  }

  Future set(ThemeBrightness set) async {
    await setStorage(key, (state = set).name);
  }
}

class LanguageCodeNotifier extends StateNotifier<LanguageCode> {
  late String key;
  LanguageCodeNotifier(key) : super(LanguageCode.en);

  Future get() async {
    state = LanguageCode.values.byName(await getStorage(key) ?? "");
  }

  Future set(LanguageCode set) async {
    await setStorage(key, (state = set).name);
  }
}

class BooleanNotifier extends StateNotifier<bool> {
  late String key;
  BooleanNotifier(key) : super(false);

  Future get() async {
    state = await getStorage(key) == "true";
  }

  Future set(bool set) async {
    await setStorage(key, (state = set).toString());
  }
}
