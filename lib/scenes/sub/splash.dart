// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/scenes/sub/login.dart';

// Project imports:
import 'package:vrc_manager/scenes/web/web_view_policies.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';

final accountConfigProvider = ChangeNotifierProvider<AccountConfigNotifier>((ref) => AccountConfigNotifier());

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
  UserPolicyConfigNotifier userPolicyConfig = ref.watch(userPolicyConfigProvider);

  if (accountConfig.isFirst) {
    await accountConfig.init();
  }
  if (userPolicyConfig.isFirst) {
    await userPolicyConfig.init();
  }

  if (!userPolicyConfig.agree) {
    return SplashData.userPolicy;
  }

  if (!accountConfig.isLogout()) {
    print("isLogout");
    return SplashData.login;
  }

  if (!await accountConfig.loggedAccount!.tokenCheck()) {
    print("tokenCheck");
    return SplashData.login;
  }

  print("home");
  return SplashData.home;
});

class VRChatMobileSplash extends ConsumerWidget {
  final Widget child;
  const VRChatMobileSplash({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<SplashData> data = ref.watch(splashProvider);

    return Scaffold(
      body: data.when(
        loading: () => SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(strokeWidth: 8),
            ),
          ),
        ),
        error: (err, stack) => Text('Error: $err'),
        data: (SplashData data) {
          switch (data) {
            case SplashData.home:
              if (Platform.isAndroid || Platform.isIOS) {
                ReceiveSharingIntent.getInitialText().then((String? initialText) {
                  if (initialText != null) {
                    urlParser(context, Uri.parse(initialText));
                  }
                });
              }
              return child;
            case SplashData.login:
              return const VRChatMobileLogin();
            case SplashData.userPolicy:
              return const VRChatMobileWebViewUserPolicy();
          }
        },
      ),
    );
  }
}
