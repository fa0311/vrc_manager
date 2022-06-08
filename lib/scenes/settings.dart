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
  const VRChatMobileSettings({Key? key}) : super(key: key);

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

  ListTile _changeLocaleDialogOption(BuildContext context, String title, String subtitle, String languageCode) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
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
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                value: theme,
                title: Text(AppLocalizations.of(context)!.darkTheme),
                subtitle: Text(AppLocalizations.of(context)!.darkThemeDetails),
                onChanged: _changeSwitch,
              ),
              const Divider(),
              ListTile(
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(AppLocalizations.of(context)!.languageDetails),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              _changeLocaleDialogOption(context, 'English', 'Translated by DeepL', 'en'),
                              _changeLocaleDialogOption(context, '日本語', 'Translated by fa0311', 'ja'),
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
