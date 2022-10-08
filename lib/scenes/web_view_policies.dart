// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrc_manager/assets/error.dart';
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

enum LaunchUrl { webview, browser, error, wait }

class _WebViewPageState extends State<VRChatMobileWebViewUserPolicy> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  static const String url = "https://github.com/fa0311/vrc_manager/blob/master/docs/user_policies/ja.md";
  LaunchUrl launchData = LaunchUrl.wait;

  Future get() async {
    if (Platform.isAndroid || Platform.isIOS) {
      launchData = LaunchUrl.webview;
    } else {
      if (await canLaunchUrl(Uri.parse(url))) {
        launchData = LaunchUrl.browser;
      } else {
        launchData = LaunchUrl.error;
        await launchUrl(Uri.parse(url));
      }
    }
  }

  @override
  initState() {
    super.initState();
    get().then((value) => setState(() {}));
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
        if (launchData == LaunchUrl.webview) {
          return const WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          );
        }
        if (launchData == LaunchUrl.error) {
          errorDialog(context, widget.appConfig, AppLocalizations.of(context)!.cantOpenBrowser);
        }

        return const Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 8,
            ),
          ),
        );
      }(),
    );
  }
}
