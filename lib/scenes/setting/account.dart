// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/assets/dialog.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/setting/token.dart';
import 'package:vrc_manager/scenes/sub/login.dart';

class VRChatMobileSettingsAccount extends StatefulWidget {
  const VRChatMobileSettingsAccount({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccount> createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<VRChatMobileSettingsAccount> {
  @override
  Widget build(BuildContext context) {
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
                      onTap: () => confirm(
                            context,
                            AppLocalizations.of(context)!.logoutConfirm,
                            AppLocalizations.of(context)!.logout,
                          ).then((value) {
                            if (!value) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const VRChatMobileLogin(),
                              ),
                              (_) => false,
                            );
                            appConfig.loggedAccount?.removeCookie();
                          })),
                  const Divider(),
                  ListTile(
                      title: Text(AppLocalizations.of(context)!.deleteLoginInfo),
                      subtitle: Text(AppLocalizations.of(context)!.deleteLoginInfoDetails),
                      onTap: () => confirm(
                            context,
                            AppLocalizations.of(context)!.deleteLoginInfoConfirm,
                            AppLocalizations.of(context)!.delete,
                          ).then((value) {
                            if (!value) return;
                            appConfig.loggedAccount?.removeUserId();
                            appConfig.loggedAccount?.removePassword();
                            appConfig.loggedAccount?.removeDisplayName();
                            appConfig.loggedAccount?.setRememberLoginInfo(false);
                          })),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.token),
                    subtitle: Text(AppLocalizations.of(context)!.tokenDetails),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const VRChatMobileTokenSetting(),
                        ),
                      )
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
                    subtitle: Text(AppLocalizations.of(context)!.accountSwitchSettingDetails),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileSettingsOtherAccount(),
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
