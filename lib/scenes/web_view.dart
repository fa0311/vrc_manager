// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/session.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class VRChatMobileWebView extends StatefulWidget {
  final String url;
  final AppConfig appConfig;

  const VRChatMobileWebView(this.appConfig, {Key? key, required this.url}) : super(key: key);

  @override
  State<VRChatMobileWebView> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<VRChatMobileWebView> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late bool openInExternalBrowser = false;
  late WebViewController controllerGlobal;
  late int timeStamp = 0;
  late String url = widget.url;
  late Widget body = WebView(
    initialUrl: widget.url,
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) {
      controllerGlobal = webViewController;
    },
    navigationDelegate: (NavigationRequest request) {
      if (openInExternalBrowser && Uri.parse(url).host != "vrchat.com") {
        openInBrowser(context, widget.appConfig, url);
        return NavigationDecision.prevent;
      } else {
        setState(() => url = request.url);
        return NavigationDecision.navigate;
      }
    },
  );

  @override
  initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      getStorage("force_external_browser").then((response) async {
        openInExternalBrowser = (response == "true");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    final cookieManager = CookieManager();

    final cookieMap = Session().decodeCookie(vrchatLoginSession.getCookie());
    for (String key in cookieMap.keys) {
      cookieManager.setCookie(
        WebViewCookie(
          name: key,
          value: cookieMap[key] ?? "",
          domain: ".vrchat.com",
        ),
      );
    }

    Future<bool> exitApp(BuildContext context) async {
      if (DateTime.now().millisecondsSinceEpoch - timeStamp < 200) {
        return true;
      } else if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        timeStamp = DateTime.now().millisecondsSinceEpoch;
        return false;
      }
      return true;
    }

    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => modalBottom(context, shareUrlListTile(context, widget.appConfig, url, browserExternalForce: true)),
            )
          ],
        ),
        body: body,
      ),
    );
  }
}
