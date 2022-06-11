// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/scenes/setting/token.dart';

class VRChatMobileSettingsAccount extends StatefulWidget {
  const VRChatMobileSettingsAccount({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccount> createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<VRChatMobileSettingsAccount> {
  _removeLoginSession() async {
    setLoginSession("login_session", "");
  }

  _removeLoginInfo() async {
    setLoginSession("userid", "");
    setLoginSession("password", "");
    setStorage("remember_login_info", "false");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context)!.logout),
                  subtitle: Text(AppLocalizations.of(context)!.logoutDetails),
                  onTap: () => {
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
                              child: Text(AppLocalizations.of(context)!.logout),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => const VRChatMobileLogin(),
                                    ),
                                    (_) => false);
                                _removeLoginSession();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.deleteLoginInfo),
                  subtitle: Text(AppLocalizations.of(context)!.deleteLoginInfoDetails),
                  onTap: () => {
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
                              child: Text(AppLocalizations.of(context)!.delete),
                              onPressed: () {
                                _removeLoginInfo();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.token),
                  subtitle: Text(AppLocalizations.of(context)!.tokenDetails),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const VRChatMobileTokenSetting(),
                        ))
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
