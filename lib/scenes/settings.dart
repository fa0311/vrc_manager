// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/main.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/setting/accessibility.dart';
import 'package:vrchat_mobile_client/scenes/setting/account.dart';
import 'package:vrchat_mobile_client/scenes/setting/help.dart';
import 'package:vrchat_mobile_client/scenes/setting/permissions.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettings extends StatefulWidget {
  final bool logged;
  final AppConfig appConfig;
  final VRChatAPI vrhatLoginSession;
  const VRChatMobileSettings(this.appConfig, this.vrhatLoginSession, {Key? key, this.logged = true}) : super(key: key);

  @override
  State<VRChatMobileSettings> createState() => _SettingPageState();
}

class _SettingPageState extends State<VRChatMobileSettings> {
  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig, widget.vrhatLoginSession);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      drawer: widget.logged ? drawer(context, widget.appConfig, widget.vrhatLoginSession) : simpledrawer(context, widget.appConfig, widget.vrhatLoginSession),
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
                        builder: (BuildContext context) => VRChatMobileSettingsAccessibility(widget.appConfig, widget.vrhatLoginSession),
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
                        builder: (BuildContext context) => VRChatMobileSettingsAccount(widget.appConfig, widget.vrhatLoginSession),
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
                        builder: (BuildContext context) => VRChatMobileSettingsPermissions(widget.appConfig, widget.vrhatLoginSession),
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
                        builder: (BuildContext context) => VRChatMobileHelp(widget.appConfig, widget.vrhatLoginSession),
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
