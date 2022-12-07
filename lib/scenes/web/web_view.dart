// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/data_class/app_config.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/session.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/share.dart';

final timeStampProvider = StateProvider<int>((ref) => 0);
final urlProvider = StateProvider<Uri?>((ref) => null);

class VRChatMobileWebView extends ConsumerWidget {
  VRChatMobileWebView({Key? key, required this.initUrl}) : super(key: key);

  late final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late final WebViewController controllerGlobal;
  final Uri initUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    final cookieManager = CookieManager();
    int timeStamp = ref.read(timeStampProvider);
    Uri url = ref.watch(urlProvider) ?? initUrl;

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
          initialUrl: url.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controllerGlobal = webViewController;
          },
          navigationDelegate: (NavigationRequest request) {
            if (ref.read(forceExternalBrowserProvider) && url.host != "vrchat.com") {
              openInBrowser(context, url);
              return NavigationDecision.prevent;
            } else {
              ref.watch(urlProvider.notifier).state = Uri.parse(request.url);
              return NavigationDecision.navigate;
            }
          },
        ),
      ),
    );
  }
}
