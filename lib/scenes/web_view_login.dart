// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:

class VRChatMobileWebViewLogin extends StatefulWidget {
  const VRChatMobileWebViewLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileWebViewLogin> createState() => _WebViewPageLoginState();
}

class _WebViewPageLoginState extends State<VRChatMobileWebViewLogin> {
  @override
  Widget build(BuildContext context) {
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
        body: WebView(
          initialUrl: "https://vrchat.com/home/login",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controllerGlobal = webViewController;
          },
          onPageFinished: (String url) {
            rootBundle.loadString('assets/js/web_login.js').then((String javaScript) {
              controllerGlobal.runJavascript(javaScript);
            });
          },
          javascriptChannels: {
            JavascriptChannel(
              name: 'VRChatMobileClientLogin',
              onMessageReceived: (result) {
                setLoginSession("login_session", result.message).then((value) => print(result.message));
              },
            )
          },
        ),
      ),
    );
  }
}
