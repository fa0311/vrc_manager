// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
    List<Future> futureListLogin = [];

    String? initialText;
    AppConfig appConfig = AppConfig();

    futureList.add(getStorage("account_index").then((value) => appConfig.accountUid = value));
    futureList.add(getStorageList("account_index_list").then((List<String> accountList) {
      for (String uid in accountList) {
        AccountConfig accountConfig = AccountConfig(uid);
        futureListLogin.add(getLoginSession("login_session", accountUid: uid).then((value) => accountConfig.cookie = value ?? ""));
        futureListLogin.add(getLoginSession("userid", accountUid: uid).then((value) => accountConfig.userid = value ?? ""));
        futureListLogin.add(getLoginSession("password", accountUid: uid).then((value) => accountConfig.password = value ?? ""));
        futureListLogin.add(getLoginSession("remember_login_info", accountUid: uid).then((value) => accountConfig.rememberLoginInfo = (value == "true")));
        appConfig.accountList.add(accountConfig);
      }
    }));

    if (widget.init && (Platform.isAndroid || Platform.isIOS)) {
      futureList.add(ReceiveSharingIntent.getInitialText().then((String? value) => initialText = value));
    }
    Future.wait(futureList).then((value) {
      Future.wait(futureListLogin).then((value) {
        if (initialText != null) {
          urlParser(context, appConfig, initialText!);
        } else if (appConfig.getLoggedAccount()?.cookie == null) {
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
      });
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
