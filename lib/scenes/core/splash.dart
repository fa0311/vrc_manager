// Dart imports:

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/web/web_view_policies.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/scroll.dart';

final accountConfigProvider = ChangeNotifierProvider<AccountConfigNotifier>((ref) => AccountConfigNotifier());
final accountListConfigProvider = ChangeNotifierProvider<AccountListConfigNotifier>((ref) => AccountListConfigNotifier());
final isFirstProvider = StateProvider<bool>((ref) => true);

enum SplashData {
  home,
  login,
  userPolicy;
}

final splashProvider = FutureProvider<SplashData>((ref) async {
  for (GridModalConfigType id in GridModalConfigType.values) {
    ref.read(gridConfigProvider(id));
  }

  AccountConfigNotifier accountConfig = ref.watch(accountConfigProvider);
  AccountListConfigNotifier accountListConfig = ref.read(accountListConfigProvider);
  UserPolicyConfigNotifier userPolicyConfig = ref.watch(userPolicyConfigProvider);

  if (accountListConfig.isFirst) {
    await accountListConfig.init();
    accountConfig.init(await accountListConfig.getLoggedAccount());
  }

  if (userPolicyConfig.isFirst) {
    await userPolicyConfig.init();
  }

  if (!userPolicyConfig.agree) {
    return SplashData.userPolicy;
  }

  if (accountConfig.isLogout()) {
    return SplashData.login;
  }

  if (!await accountConfig.loggedAccount!.tokenCheck()) {
    return SplashData.login;
  }

  return SplashData.home;
});

class VRChatMobileSplash extends ConsumerWidget {
  final Widget child;
  final Widget login;
  const VRChatMobileSplash({
    Key? key,
    this.child = const VRChatMobileHome(),
    this.login = const VRChatMobileLogin(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<SplashData> data = ref.watch(splashProvider);
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    textStream(context: context, forceExternal: accessibilityConfig.forceExternalBrowser);

    return Scaffold(
      body: SafeArea(
        child: data.when(
          loading: () => const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(strokeWidth: 8),
            ),
          ),
          error: (e, trace) {
            logger.w(getMessage(e), e, trace);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
            return ScrollWidget(
              onRefresh: () => ref.refresh(splashProvider.future),
              child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
            );
          },
          data: (SplashData data) {
            switch (data) {
              case SplashData.home:
                () async {
                  if (!Platform.isAndroid && !Platform.isIOS) return;
                  if (!ref.read(isFirstProvider)) return;
                  String? initialText = await ReceiveSharingIntent.getInitialText();
                  if (initialText == null) return;
                  Widget? value = await urlParser(url: Uri.parse(initialText), forceExternal: accessibilityConfig.forceExternalBrowser);
                  if (value == null) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => value));
                  ref.read(isFirstProvider.notifier).state = false;
                }();
                return child;
              case SplashData.login:
                return login;
              case SplashData.userPolicy:
                return const VRChatMobileWebViewUserPolicy();
            }
          },
        ),
      ),
    );
  }
}
