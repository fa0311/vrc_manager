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

  bool theme = false;
  _changeSwitch(bool e) {
    setStorage("theme_brightness", e ? "dark" : "light").then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobile(),
          ),
          (_) => false);
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
              SwitchListTile(
                value: theme,
                title: Text(AppLocalizations.of(context)!.darkTheme),
                subtitle: Text("${AppLocalizations.of(context)!.darkThemeDetails1}\n${AppLocalizations.of(context)!.darkThemeDetails2}"),
                onChanged: _changeSwitch,
              ),
              const Divider(),
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
