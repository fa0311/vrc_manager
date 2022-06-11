// Flutter imports:
import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/session.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';

class VRChatMobileWebView extends StatefulWidget {
  final String url;

  const VRChatMobileWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<VRChatMobileWebView> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<VRChatMobileWebView> {
  @override
  Widget build(BuildContext context) {
    final cookieManager = CookieManager();

    getLoginSession("login_session").then((cookie) {
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
    });

    late WebViewController controllerGlobal;

    Future<bool> _exitApp(BuildContext contex) async {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return false;
      }
      return true;
    }

    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
          appBar: AppBar(
            actions: [simpleShare(context, widget.url)],
          ),
          body: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controllerGlobal = webViewController;
            },
          ),
        ));
  }
}
