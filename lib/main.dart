// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/material.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';

main() {
  runApp(const VRChatMobile());
}

class VRChatMobile extends StatefulWidget {
  const VRChatMobile({Key? key}) : super(key: key);

  @override
  State<VRChatMobile> createState() => _PageState();
}

class _PageState extends State<VRChatMobile> with WidgetsBindingObserver {
  String theme = "light";
  String locale = "en";

  _PageState() {
    getStorage("theme_brightness").then((response) => setState(() => theme = response ?? "light"));
    getStorage("language_code").then((response) => setState(() => locale = response ?? "en"));
  }

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(
      const VRChatMobileHome(),
      theme,
      Locale(locale, ''),
    );
  }
}
