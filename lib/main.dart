// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/material.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';

AppConfig appConfig = AppConfig();
main() {
  runApp(const ProviderScope(child: VRChatMobile()));
}

class VRChatMobile extends ConsumerWidget {
  const VRChatMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return getMaterialApp(const VRChatMobileSplash(), ref);
  }
}
