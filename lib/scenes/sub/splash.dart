// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/web/web_view_policies.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';

final accountConfigProvider = StateNotifierProvider<AccountConfigNotifier, AccountConfig?>((ref) => AccountConfigNotifier(null));

enum SplashData {
  home,
  login,
  userPolicy;
}

final splashProvider = FutureProvider<SplashData>((ref) async {
  for (GridModalConfigType id in GridModalConfigType.values) {
    ref.read(gridConfigProvider(id));
  }

  AccountConfigNotifier accountConfig = ref.read(accountConfigProvider.notifier);
  UserPolicyConfigNotifier userPolicyConfig = ref.read(userPolicyConfigProvider);

  await accountConfig.init();
  await userPolicyConfig.init();

  if (!userPolicyConfig.agree) {
    return SplashData.userPolicy;
  }
  return SplashData.home;
});

class VRChatMobileSplash extends ConsumerWidget {
  const VRChatMobileSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<SplashData> data = ref.watch(splashProvider);

    goHome() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobileHome(),
        ),
        (_) => false,
      );
    }

    goLogin() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobileLogin(),
        ),
        (_) => false,
      );
    }

    goWebViewUserPolicy() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobileWebViewUserPolicy(),
        ),
        (_) => false,
      );
    }

/*
      if (!userPolicyConfig.agree) {
        goWebViewUserPolicy(context);
      } else if (!appConfig.isLogout()) {
        goLogin(context);
      } else if (Platform.isAndroid || Platform.isIOS) {
        ReceiveSharingIntent.getInitialText().then((String? initialText) {
          if (initialText != null) {
            urlParser(context, Uri.parse(initialText));
          } else {
            goHome(context);
          }
        });
      } else {
        goHome(context);
      }
      */

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: data.when(
              loading: () => const SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 8)),
              error: (err, stack) => Text('Error: $err'),
              data: (SplashData data) {
                switch (data) {
                  case SplashData.home:
                    goHome();
                    return Container();
                  case SplashData.login:
                    goLogin();
                    return Container();
                  case SplashData.userPolicy:
                    goWebViewUserPolicy();
                    return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
