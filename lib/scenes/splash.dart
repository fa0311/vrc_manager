// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/home.dart';
import 'package:vrc_manager/scenes/login.dart';
import 'package:vrc_manager/scenes/web_view_policies.dart';

class VRChatMobileSplash extends StatefulWidget {
  const VRChatMobileSplash({Key? key}) : super(key: key);
  @override
  State<VRChatMobileSplash> createState() => _SplashState();
}

class _SplashState extends State<VRChatMobileSplash> {
  @override
  initState() {
    super.initState();

    appConfig.get(context).then((_) async {
      if (!appConfig.agreedUserPolicy) {
        goWebViewUserPolicy();
      } else if (!appConfig.isLogout()) {
        goLogin();
      } else if (Platform.isAndroid || Platform.isIOS) {
        ReceiveSharingIntent.getInitialText().then((String? initialText) {
          if (initialText != null) {
            urlParser(context, appConfig, initialText);
          } else {
            goHome();
          }
        });
      } else {
        goHome();
      }
    });
  }

  goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileHome(appConfig),
      ),
      (_) => false,
    );
  }

  goLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileLogin(appConfig),
      ),
      (_) => false,
    );
  }

  goWebViewUserPolicy() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWebViewUserPolicy(appConfig),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
