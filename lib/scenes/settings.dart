// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/scenes/setting/accessibility.dart';
import 'package:vrchat_mobile_client/scenes/setting/account.dart';
import 'package:vrchat_mobile_client/scenes/setting/help.dart';

// Project imports:
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettings extends StatefulWidget {
  final bool logged;
  const VRChatMobileSettings({Key? key, this.logged = true}) : super(key: key);

  @override
  State<VRChatMobileSettings> createState() => _SettingPageState();
}

class _SettingPageState extends State<VRChatMobileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      drawer: widget.logged ? drawr(context) : simpleDrawr(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context)!.accessibility),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const VRChatMobileSettingsAccessibility(),
                        ))
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.account),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const VRChatMobileSettingsAccount(),
                        ))
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.help),
                  onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileHelp(),
                      ),
                      (_) => false),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
