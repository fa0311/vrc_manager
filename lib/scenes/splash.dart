// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:vrchat_mobile_client/api/main.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
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
  @override
  initState() {
    super.initState();
    List<Future> futureList = [];

    String? cookie;
    String? initialText;

    futureList.add(getLoginSession("login_session").then((value) => cookie = value).catchError((status) {}));
    if (widget.init && (Platform.isAndroid || Platform.isIOS)) {
      futureList.add(ReceiveSharingIntent.getInitialText().then((String? value) => initialText = value));
    }

    Future.wait(futureList).then((value) {
      VRChatAPI vrhatLoginSession = VRChatAPI(cookie: cookie!);
      AppConfig appConfig = AppConfig();

      if (initialText != null) {
        urlParser(context, appConfig, vrhatLoginSession, initialText!);
      } else {
        if (cookie == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileLogin(appConfig, vrhatLoginSession),
            ),
            (_) => false,
          );
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => VRChatMobileHome(appConfig, vrhatLoginSession),
          ),
          (_) => false,
        );
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
