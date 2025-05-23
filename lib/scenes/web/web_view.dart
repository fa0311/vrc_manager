// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/assets/session.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';

final timeStampProvider = StateProvider<int>((ref) => 0);
final urlProvider = StateProvider.autoDispose<Uri?>((ref) => null);
final webViewControllerProvider =
    StateProvider<InAppWebViewController?>((ref) => null);

class VRChatMobileWebView extends ConsumerWidget {
  const VRChatMobileWebView({super.key, required this.initUrl});

  final Uri initUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig =
        ref.watch(accessibilityConfigProvider);
    String cookies =
        ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "";

    InAppWebViewController? webViewController =
        ref.watch(webViewControllerProvider);

    Uri url = ref.watch(urlProvider) ?? initUrl;

    final cookieMap = Session().decodeCookie(cookies);

    // Initialize cookies
    void setCookies() async {
      CookieManager cookieManager = CookieManager.instance();
      for (String key in cookieMap.keys) {
        await cookieManager.setCookie(
          url: WebUri(url.toString()),
          name: key,
          value: cookieMap[key] ?? "",
          domain: VRChatAssets.vrchat.host,
        );
      }
    }

    setCookies();

    Future<bool> exitApp(BuildContext context) async {
      if (DateTime.now().millisecondsSinceEpoch - ref.read(timeStampProvider) <
          200) {
        return true;
      } else if (webViewController != null &&
          await webViewController.canGoBack()) {
        await webViewController.goBack();
        ref.read(timeStampProvider.notifier).state =
            DateTime.now().millisecondsSinceEpoch;
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
                  builder: () =>
                      ShareUrlListTile(url: url, browserExternalForce: true),
                );
              },
            ),
          ],
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url.toString())),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            ref.read(webViewControllerProvider.notifier).state = controller;
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var request = navigationAction.request;
            var requestUrl = request.url;

            if (requestUrl != null &&
                ref.watch(accessibilityConfigProvider).forceExternalBrowser &&
                requestUrl.host != VRChatAssets.vrchat.host) {
              Widget? value = await openInBrowser(
                url: Uri.parse(requestUrl.toString()),
                forceExternal: accessibilityConfig.forceExternalBrowser,
              );
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => value),
                );
              }
              return NavigationActionPolicy.CANCEL;
            } else if (requestUrl != null) {
              ref.read(urlProvider.notifier).state =
                  Uri.parse(requestUrl.toString());
              return NavigationActionPolicy.ALLOW;
            }
            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
  }
}
