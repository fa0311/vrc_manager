// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/scenes/setting/accessibility.dart';
import 'package:vrchat_mobile_client/scenes/setting/account.dart';
import 'package:vrchat_mobile_client/scenes/setting/help.dart';
import 'package:vrchat_mobile_client/scenes/setting/permissions.dart';
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
      drawer: widget.logged ? drawer(context) : simpledrawer(context),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.accessibility,
                        ),
                      ],
                    ),
                    title: Text(AppLocalizations.of(context)!.accessibility),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileSettingsAccessibility(),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.account_circle,
                        ),
                      ],
                    ),
                    title: Text(AppLocalizations.of(context)!.account),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileSettingsAccount(),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.admin_panel_settings,
                        ),
                      ],
                    ),
                    title: Text(AppLocalizations.of(context)!.permissions),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileSettingsPermissions(),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.help,
                        ),
                      ],
                    ),
                    title: Text(AppLocalizations.of(context)!.help),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileHelp(),
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
