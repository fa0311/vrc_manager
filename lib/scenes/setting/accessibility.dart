// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/modal/locale.dart';
import 'package:vrc_manager/widgets/modal/theme.dart';

class VRChatMobileSettingsAccessibility extends StatefulWidget {
  const VRChatMobileSettingsAccessibility({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccessibility> createState() => _SettingAccessibilityPageState();
}

class _SettingAccessibilityPageState extends State<VRChatMobileSettingsAccessibility> {
  @override
  Widget build(BuildContext context) {
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
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(appConfig.languageCode.text),
                  onTap: () => showLocaleModal(context),
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(appConfig.themeBrightness.toLocalization(context)),
                  onTap: () => showThemeBrightnessModal(context),
                ),
                const Divider(),
                SwitchListTile(
                  value: appConfig.dontShowErrorDialog,
                  title: Text(AppLocalizations.of(context)!.dontShowErrorDialog),
                  subtitle: Text(AppLocalizations.of(context)!.dontShowErrorDialogDetails),
                  onChanged: (bool e) => appConfig.setDontShowErrorDialog(e).then((value) => setState((() {}))),
                ),
                if (!Platform.isWindows) ...[
                  const Divider(),
                  SwitchListTile(
                    value: appConfig.forceExternalBrowser,
                    title: Text(AppLocalizations.of(context)!.forceExternalBrowser),
                    subtitle: Text(AppLocalizations.of(context)!.forceExternalBrowserDetails),
                    onChanged: (bool e) => appConfig.setForceExternalBrowser(e).then((value) => setState(() {})),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
