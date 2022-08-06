// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/session.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class VRChatMobileWebView extends StatefulWidget {
  final String url;

  const VRChatMobileWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<VRChatMobileWebView> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<VRChatMobileWebView> {
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
        openInBrowser(context, url);
        return NavigationDecision.prevent;
      } else {
        setState(() => url = request.url);
        return NavigationDecision.navigate;
      }
    },
  );

  _WebViewPageState() {
    if (Platform.isAndroid || Platform.isIOS) {
      getStorage("force_external_browser").then((response) async {
        openInExternalBrowser = (response == "true");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    final cookieManager = CookieManager();

    getLoginSession("login_session").then(
      (cookie) {
        final cookieMap = Session().decodeCookie(cookie ?? "");
        for (String key in cookieMap.keys) {
          cookieManager.setCookie(
            WebViewCookie(
              name: key,
              value: cookieMap[key] ?? "",
              domain: ".vrchat.com",
            ),
          );
        }
      },
    );

    Future<bool> _exitApp(BuildContext contex) async {
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
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          actions: [simpleShare(context, url)],
        ),
        body: body,
      ),
    );
  }
}
