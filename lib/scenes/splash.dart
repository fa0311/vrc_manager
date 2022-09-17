// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';

class VRChatMobileSplash extends StatefulWidget {
  final bool init;
  const VRChatMobileSplash({Key? key, this.init = false}) : super(key: key);
  @override
  State<VRChatMobileSplash> createState() => _SplashState();
}

class _SplashState extends State<VRChatMobileSplash> {
  push(AppConfig appConfig) {
    if (!appConfig.isLogined()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileLogin(
            appConfig,
          ),
        ),
        (_) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileHome(
            appConfig,
          ),
        ),
        (_) => false,
      );
    }
  }

  @override
  initState() {
    super.initState();

    AppConfig appConfig = AppConfig();
    appConfig.get().then((_) async {
      if (widget.init && (Platform.isAndroid || Platform.isIOS)) {
        ReceiveSharingIntent.getInitialText().then((String? initialText) {
          if (initialText != null) {
            urlParser(context, appConfig, initialText);
          } else {
            push(appConfig);
          }
        });
      } else {
        push(appConfig);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 30,
                left: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}