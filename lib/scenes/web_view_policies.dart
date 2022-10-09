// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/scenes/home.dart';
import 'package:vrc_manager/widgets/share.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/data_class/app_config.dart';

class VRChatMobileWebViewUserPolicy extends StatefulWidget {
  final AppConfig appConfig;

  const VRChatMobileWebViewUserPolicy(this.appConfig, {Key? key}) : super(key: key);

  @override
  State<VRChatMobileWebViewUserPolicy> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<VRChatMobileWebViewUserPolicy> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  static const String url = "https://github.com/fa0311/vrc_manager/blob/master/docs/user_policies/ja.md";

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userPolicy),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => modalBottom(context, shareUrlListTile(context, widget.appConfig, url, browserExternalForce: true)),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  AppLocalizations.of(context)!.disagree,
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: () async {
                  await widget.appConfig.setAgreedUserPolicy(true);
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileHome(widget.appConfig),
                    ),
                    (_) => false,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.agree,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: () {
        if (Platform.isAndroid || Platform.isIOS) {
          return const WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          );
        } else {
          openInBrowser(context, widget.appConfig, url, forceExternal: true);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.lookAtYourBrowser,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }(),
    );
  }
}
