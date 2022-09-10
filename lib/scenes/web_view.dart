// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/session.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class VRChatMobileWebView extends StatefulWidget {
  final String url;
  final AppConfig appConfig;
  final VRChatAPI vrhatLoginSession;
  const VRChatMobileWebView(this.appConfig, this.vrhatLoginSession, {Key? key, required this.url}) : super(key: key);

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
        openInBrowser(context, widget.appConfig, widget.vrhatLoginSession, url);
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
    textStream(context, widget.appConfig, widget.vrhatLoginSession);
    final cookieManager = CookieManager();

    final cookieMap = Session().decodeCookie(widget.vrhatLoginSession.vrchatSession.headers["cookie"] ?? "");
    for (String key in cookieMap.keys) {
      cookieManager.setCookie(
        WebViewCookie(
          name: key,
          value: cookieMap[key] ?? "",
          domain: ".vrchat.com",
        ),
      );
    }

    Future<bool> exitApp(BuildContext contex) async {
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
          actions: [simpleShare(context, url)],
        ),
        body: body,
      ),
    );
  }
}
