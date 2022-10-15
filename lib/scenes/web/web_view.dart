// Flutter imports:
import 'package:flutter/material.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/session.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileWebView extends StatefulWidget {
  final String url;

  const VRChatMobileWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<VRChatMobileWebView> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<VRChatMobileWebView> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late WebViewController controllerGlobal;
  late int timeStamp = 0;
  late String url = widget.url;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
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
              onPressed: () => modalBottom(context, shareUrlListTile(context, url, browserExternalForce: true)),
            )
          ],
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controllerGlobal = webViewController;
          },
          navigationDelegate: (NavigationRequest request) {
            if (appConfig.forceExternalBrowser && Uri.parse(url).host != "vrchat.com") {
              openInBrowser(context, url);
              return NavigationDecision.prevent;
            } else {
              setState(() => url = request.url);
              return NavigationDecision.navigate;
            }
          },
        ),
      ),
    );
  }
}
