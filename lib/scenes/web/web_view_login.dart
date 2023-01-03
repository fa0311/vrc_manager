// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/session.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/scroll.dart';

final GlobalKey webViewKey = GlobalKey();

final timeStampProvider = StateProvider<int>((ref) => 0);
final urlProvider = StateProvider.autoDispose<Uri?>((ref) => null);
final webViewControllerProvider = StateProvider<InAppWebViewController?>((ref) => null);

final webViewInitProvider = FutureProvider.autoDispose<void>((ref) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
  CookieManager cookieManager = CookieManager.instance();
  await cookieManager.deleteAllCookies();
  final cookieMap = Session().decodeCookie(vrchatLoginSession.getCookie());
  await Future.wait([
    for (String key in cookieMap.keys)
      cookieManager.setCookie(
        name: key,
        url: VRChatAssets.vrchat,
        value: cookieMap[key] ?? "",
        isSecure: true,
        isHttpOnly: true,
      )
  ]);
});

class VRChatMobileWebViewLogin extends ConsumerWidget {
  const VRChatMobileWebViewLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Uri initUrl = ref.watch(urlProvider) ?? VRChatAssets.login;
    InAppWebViewController? webViewController = ref.watch(webViewControllerProvider);
    AsyncValue<void> data = ref.watch(webViewInitProvider);
    Future<bool> exitApp(BuildContext context) async {
      if (DateTime.now().millisecondsSinceEpoch - ref.read(timeStampProvider) < 200) {
        return true;
      } else if (await webViewController!.canGoBack()) {
        webViewController.goBack();
        ref.read(timeStampProvider.notifier).state = DateTime.now().millisecondsSinceEpoch;
        return false;
      }
      return true;
    }

    return WillPopScope(
      onWillPop: () => exitApp(context),
      child: Scaffold(
        appBar: AppBar(),
        body: data.when(
          loading: () => const Loading(),
          error: (e, trace) {
            logger.w(getMessage(e), e, trace);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
            return ScrollWidget(
              onRefresh: () => ref.refresh((webViewInitProvider.future)),
              child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
            );
          },
          data: (data) => InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: initUrl),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController value) {
              ref.read(webViewControllerProvider.notifier).state = value;
            },
            onTitleChanged: (controller, title) async {
              if (title != VRChatAssets.homeTitle) return;
              CookieManager cookieManager = CookieManager.instance();
              List<Cookie> cookieList = await cookieManager.getCookies(url: VRChatAssets.vrchat);
              Map<String, String> cookieMap = {};
              for (Cookie cookie in cookieList) {
                cookieMap[cookie.name] = cookie.value;
              }
              AccountConfig config = ref.read(loginDataProvider).accountConfig;
              config.setCookie(Session().encodeCookie(cookieMap));
              ref.read(accountListConfigProvider).addAccount(config);
              await ref.read(accountConfigProvider).login(config);
            },
          ),
        ),
      ),
    );
  }
}
