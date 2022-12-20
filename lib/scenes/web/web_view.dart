// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/session.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';

final timeStampProvider = StateProvider<int>((ref) => 0);
final urlProvider = StateProvider<Uri?>((ref) => null);
final webViewControllerProvider = StateProvider<WebViewController?>((ref) => null);

class VRChatMobileWebView extends ConsumerWidget {
  const VRChatMobileWebView({Key? key, required this.initUrl}) : super(key: key);

  final Uri initUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);

    WebViewController? webViewController = ref.read(webViewControllerProvider);

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
      } else if (await webViewController!.canGoBack()) {
        webViewController!.goBack();
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
              onPressed: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => ShareUrlListTile(url: url, browserExternalForce: true),
                );
              },
            ),
          ],
        ),
        body: WebView(
          initialUrl: url.toString(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController value) {
            webViewController = value;
          },
          navigationDelegate: (NavigationRequest request) {
            if (ref.read(accessibilityConfigProvider).forceExternalBrowser && url.host != "vrchat.com") {
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
