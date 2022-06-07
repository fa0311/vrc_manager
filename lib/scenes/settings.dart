import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/scenes/setting/token.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void _changeSwitch(bool e) {
    setStorage("theme_brightness", e ? "dark" : "light").then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobile(),
          ),
          (_) => false);
    });
    setState(() => theme = e);
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
