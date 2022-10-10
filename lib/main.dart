// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/material.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';

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
  @override
  initState() {
    super.initState();
    appConfig.setState = setState;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getMaterialApp(const VRChatMobileSplash());
  }
}
