// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/web/web_view_policies.dart';

class VRChatMobileSplash extends ConsumerWidget {
  const VRChatMobileSplash({Key? key}) : super(key: key);

  goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const VRChatMobileHome(),
      ),
      (_) => false,
    );
  }

  goLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const VRChatMobileLogin(),
      ),
      (_) => false,
    );
  }

  goWebViewUserPolicy(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWebViewUserPolicy(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    appConfig.get(context, ref).then((_) async {
      if (!ref.read(agreedUserPolicyProvider)) {
        goWebViewUserPolicy(context);
      } else if (!appConfig.isLogout()) {
        goLogin(context);
      } else if (Platform.isAndroid || Platform.isIOS) {
        ReceiveSharingIntent.getInitialText().then((String? initialText) {
          if (initialText != null) {
            urlParser(context, Uri.parse(initialText));
          } else {
            goHome(context);
          }
        });
      } else {
        goHome(context);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
