// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/accessibility.dart';
import 'package:vrc_manager/scenes/setting/account.dart';
import 'package:vrc_manager/scenes/setting/help.dart';
import 'package:vrc_manager/scenes/setting/permissions.dart';

class VRChatMobileSettings extends ConsumerWidget {
  const VRChatMobileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: SafeArea(
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
                      builder: (BuildContext context) => const VRChatMobileSplash(
                        login: VRChatMobileSettingsAccessibility(),
                        child: VRChatMobileSettingsAccessibility(),
                      ),
                    ),
                  ),
                ),
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
                      builder: (BuildContext context) => const VRChatMobileSplash(
                        login: VRChatMobileSettingsAccount(),
                        child: VRChatMobileSettingsAccount(),
                      ),
                    ),
                  ),
                ),
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
                      builder: (BuildContext context) => const VRChatMobileSplash(
                        login: VRChatMobileSettingsPermissions(),
                        child: VRChatMobileSettingsPermissions(),
                      ),
                    ),
                  ),
                ),
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
                      builder: (BuildContext context) => const VRChatMobileSplash(
                        login: VRChatMobileHelp(),
                        child: VRChatMobileHelp(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
