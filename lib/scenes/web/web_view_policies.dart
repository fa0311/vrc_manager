// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:vrc_manager/assets.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileWebViewUserPolicy extends ConsumerWidget {
  const VRChatMobileWebViewUserPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userPolicy),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.translate,
            ),
            onPressed: () => showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => const LocaleModal(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareUrlListTile(url: Assets.userPolicy, browserExternalForce: true),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
              ),
            ],
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text(
                      AppLocalizations.of(context)!.disagree,
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(userPolicyConfigProvider).setAgree(true);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.agree,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: () {
        if (Platform.isAndroid || Platform.isIOS) {
          return WebView(
            initialUrl: Assets.userPolicy.toString(),
            javascriptMode: JavascriptMode.unrestricted,
          );
        } else {
          openInBrowser(url: Assets.userPolicy, forceExternal: true).then((value) {
            if (value == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => value),
            );
          });

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.lookAtYourBrowser,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }(),
    );
  }
}
