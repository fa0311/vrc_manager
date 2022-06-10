// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/scenes/setting/token.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettings extends StatefulWidget {
  final bool logged;
  const VRChatMobileSettings({Key? key, this.logged = true}) : super(key: key);

  @override
  State<VRChatMobileSettings> createState() => _SettingPageState();
}

class _SettingPageState extends State<VRChatMobileSettings> {
  _removeLoginSession() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'LoginSession');
  }

  _removeLoginInfo() async {
    setLoginSession("UserId", "");
    setLoginSession("Password", "");
    setStorage("remember_login_info", "false");
  }

  bool theme = false;
  bool autoReadMore = false;

  _changeSwitchTheme(bool e) {
    setStorage("theme_brightness", e ? "dark" : "light").then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobile(),
          ),
          (_) => false);
    });
  }

  _changeSwitchAutoReadMore(bool e) {
    setStorage("auto_read_more", e ? "true" : "false").then((response) {
      setState(() => autoReadMore = e);
    });
  }

  ListTile _changeLocaleDialogOption(BuildContext context, String title, String languageCode) {
    return ListTile(
      title: Text(title),
      subtitle: Text(AppLocalizations.of(context)!.translaterDetails(lookupAppLocalizations(Locale(languageCode, "")).contributor)),
      onTap: () async {
        setStorage("language_code", languageCode).then((response) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const VRChatMobile(),
              ),
              (_) => false);
        });
      },
    );
  }

  _SettingPageState() {
    getStorage("theme_brightness").then((response) {
      setState(() => theme = (response == "dark"));
    });
    getStorage("auto_read_more").then((response) {
      setState(() => autoReadMore = (response == "true"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      drawer: widget.logged ? drawr(context) : simpleDrawr(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(AppLocalizations.of(context)!.languageDetails),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      builder: (BuildContext context) => SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              _changeLocaleDialogOption(context, 'English', 'en'),
                              _changeLocaleDialogOption(context, '日本語', 'ja'),
                            ],
                          )))),
              const Divider(),
              SwitchListTile(
                value: theme,
                title: Text(AppLocalizations.of(context)!.darkTheme),
                subtitle: Text("${AppLocalizations.of(context)!.darkThemeDetails1}\n${AppLocalizations.of(context)!.darkThemeDetails2}"),
                onChanged: _changeSwitchTheme,
              ),
              const Divider(),
              SwitchListTile(
                value: autoReadMore,
                title: Text(AppLocalizations.of(context)!.autoReadMore),
                subtitle: Text("${AppLocalizations.of(context)!.autoReadMoreDetails1}\n${AppLocalizations.of(context)!.autoReadMoreDetails2}"),
                onChanged: _changeSwitchAutoReadMore,
              ),
              const Divider(),
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
    );
  }
}
