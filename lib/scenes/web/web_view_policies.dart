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
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileWebViewUserPolicy extends ConsumerWidget {
  const VRChatMobileWebViewUserPolicy({Key? key}) : super(key: key);

  static Uri url = Uri.https("github.com", "/fa0311/vrc_manager/blob/master/docs/user_policies/ja.md");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userPolicy),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareUrlListTile(url: url, browserExternalForce: true),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(30, 0, 0, 0),
              spreadRadius: 5,
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileHome(),
                      ),
                      (_) => false,
                    );
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
      body: () {
        if (Platform.isAndroid || Platform.isIOS) {
          return WebView(
            initialUrl: url.toString(),
            javascriptMode: JavascriptMode.unrestricted,
          );
        } else {
          openInBrowser(url: url, forceExternal: true).then((value) {
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
