// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/web/web_view_policies.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';

final accountConfigProvider = ChangeNotifierProvider<AccountConfigNotifier>((ref) => AccountConfigNotifier());

class VRChatMobileSplash extends ConsumerWidget {
  const VRChatMobileSplash({Key? key}) : super(key: key);

  goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const VRChatMobileHome(),
      ),
      (_) => false,
    );
  }

  goLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const VRChatMobileLogin(),
      ),
      (_) => false,
    );
  }

  goWebViewUserPolicy(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWebViewUserPolicy(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    for (GridModalConfigType id in GridModalConfigType.values) {
      ref.read(gridConfigProvider(id));
    }

    // AccountConfigNotifier accountConfig = ref.watch(accountConfigProvider);

    UserPolicyConfigNotifier userPolicyConfig = ref.watch(userPolicyConfigProvider);

    appConfig.get(context, ref).then((_) async {
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
    });

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
