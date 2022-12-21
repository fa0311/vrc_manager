// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/setting/token.dart';

class VRChatMobileSettingsAccount extends ConsumerWidget {
  const VRChatMobileSettingsAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.logout),
                    subtitle: Text(AppLocalizations.of(context)!.logoutDetails),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.logoutConfirm),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(accountConfigProvider).loggedAccount!.removeCookie();
                                  ref.read(accountConfigProvider).login(ref.read(accountConfigProvider).loggedAccount!);
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.logout),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.deleteLoginInfo),
                    subtitle: Text(AppLocalizations.of(context)!.deleteLoginInfoDetails),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.deleteLoginInfoConfirm),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.cancel),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(accountConfigProvider).loggedAccount!
                                    ..removeUserId()
                                    ..removePassword()
                                    ..removeDisplayName()
                                    ..setRememberLoginInfo(false);
                                  ref.read(accountConfigProvider).login(ref.read(accountConfigProvider).loggedAccount!);
                                  Navigator.pop(context);
                                },
                                child: Text(AppLocalizations.of(context)!.delete),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.token),
                    subtitle: Text(AppLocalizations.of(context)!.tokenDetails),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileSplash(
                            login: VRChatMobileTokenSetting(),
                            child: VRChatMobileTokenSetting(),
                          ),
                        ),
                      )
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
                    subtitle: Text(AppLocalizations.of(context)!.accountSwitchSettingDetails),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSplash(
                          login: VRChatMobileSettingsOtherAccount(),
                          child: VRChatMobileSettingsOtherAccount(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
