// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/material.dart';
import 'package:vrc_manager/scenes/splash.dart';

AppConfig appConfig = AppConfig();
main() {
  runApp(const VRChatMobile());
}

class VRChatMobile extends StatefulWidget {
  const VRChatMobile({Key? key}) : super(key: key);

  @override
  State<VRChatMobile> createState() => _PageState();
}

class _PageState extends State<VRChatMobile> {
  String theme = "light";
  String locale = "en";

  _PageState() {
    getStorage("theme_brightness").then((response) => setState(() => theme = response ?? "light"));
    getStorage("language_code").then((response) => setState(() => locale = response ?? "en"));
  }

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(
      const VRChatMobileSplash(),
      theme,
      Locale(locale, ''),
    );
  }
}
