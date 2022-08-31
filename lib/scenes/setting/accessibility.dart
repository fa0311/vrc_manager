// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/widgets/change_locale_dialog.dart';

class VRChatMobileSettingsAccessibility extends StatefulWidget {
  const VRChatMobileSettingsAccessibility({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccessibility> createState() => _SettingAccessibilityPageState();
}

class _SettingAccessibilityPageState extends State<VRChatMobileSettingsAccessibility> {
  bool theme = false;
  bool forceExternalBrowser = false;
  bool sontShowErrorDialog = false;

  _changeSwitchTheme(bool e) {
    setStorage("theme_brightness", e ? "dark" : "light").then(
      (_) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobile(),
        ),
        (_) => false,
      ),
    );
  }

  _changeSwitchForceExternalBrowser(bool e) {
    setStorage("force_external_browser", e ? "true" : "false").then(
      (_) => setState(() => forceExternalBrowser = e),
    );
  }

  _changeSwitchShowErrorDialog(bool e) {
    setStorage("dont_show_error_dialog", e ? "true" : "false").then(
      (_) => setState(() => sontShowErrorDialog = e),
    );
  }

  _SettingAccessibilityPageState() {
    getStorage("theme_brightness").then(
      (response) {
        setState(
          () => theme = (response == "dark"),
        );
      },
    );
    getStorage("force_external_browser").then(
      (response) {
        setState(
          () => forceExternalBrowser = (response == "true"),
        );
      },
    );
    getStorage("dont_show_error_dialog").then(
      (response) {
        setState(
          () => sontShowErrorDialog = (response == "true"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
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
                    title: Text(AppLocalizations.of(context)!.language),
                    subtitle: Text(AppLocalizations.of(context)!.languageDetails),
                    onTap: () => showLocaleModalBottomSheet(context),
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: theme,
                    title: Text(AppLocalizations.of(context)!.darkTheme),
                    subtitle: Text("${AppLocalizations.of(context)!.darkThemeDetails1}\n${AppLocalizations.of(context)!.darkThemeDetails2}"),
                    onChanged: _changeSwitchTheme,
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: sontShowErrorDialog,
                    title: Text(AppLocalizations.of(context)!.dontShowErrorDialog),
                    subtitle: Text(AppLocalizations.of(context)!.dontShowErrorDialogDetails),
                    onChanged: _changeSwitchShowErrorDialog,
                  ),
                  if (!Platform.isWindows) const Divider(),
                  if (!Platform.isWindows)
                    SwitchListTile(
                      value: forceExternalBrowser,
                      title: Text(AppLocalizations.of(context)!.forceExternalBrowser),
                      subtitle: Text(AppLocalizations.of(context)!.forceExternalBrowserDetails),
                      onChanged: _changeSwitchForceExternalBrowser,
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
