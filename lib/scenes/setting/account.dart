// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/main.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/dialog.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/scenes/setting/other_account.dart';
import 'package:vrchat_mobile_client/scenes/setting/token.dart';

class VRChatMobileSettingsAccount extends StatefulWidget {
  final AppConfig appConfig;
  final VRChatAPI vrhatLoginSession;
  const VRChatMobileSettingsAccount(this.appConfig, this.vrhatLoginSession, {Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccount> createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<VRChatMobileSettingsAccount> {
  _removeLoginSession() async {
    removeLoginSession("login_session", "");
  }

  _removeLoginInfo() async {
    removeLoginSession("userid", "");
    removeLoginSession("password", "");
    removeLoginSession("displayname", "");
    setStorage("remember_login_info", "false");
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig, widget.vrhatLoginSession);
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
                            () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => VRChatMobileLogin(widget.appConfig, widget.vrhatLoginSession),
                                ),
                                (_) => false,
                              );
                              _removeLoginSession();
                            },
                          )),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.deleteLoginInfo),
                    subtitle: Text(AppLocalizations.of(context)!.deleteLoginInfoDetails),
                    onTap: () => confirm(
                      context,
                      AppLocalizations.of(context)!.deleteLoginInfoConfirm,
                      AppLocalizations.of(context)!.delete,
                      () {
                        _removeLoginInfo();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.token),
                    subtitle: Text(AppLocalizations.of(context)!.tokenDetails),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VRChatMobileTokenSetting(widget.appConfig, widget.vrhatLoginSession),
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
                        builder: (BuildContext context) => VRChatMobileSettingsOtherAccount(widget.appConfig, widget.vrhatLoginSession, drawer: false),
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
