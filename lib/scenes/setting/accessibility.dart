// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';

class VRChatMobileSettingsAccessibility extends StatefulWidget {
  const VRChatMobileSettingsAccessibility({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsAccessibility> createState() => _SettingAccessibilityPageState();
}

class _SettingAccessibilityPageState extends State<VRChatMobileSettingsAccessibility> {
  bool theme = false;
  bool forceExternalBrowser = false;

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

  ListTile _changeLocaleDialogOption(BuildContext context, String title, String languageCode) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        AppLocalizations.of(context)!.translaterDetails(lookupAppLocalizations(
          Locale(languageCode, ""),
        ).contributor),
      ),
      onTap: () async {
        setStorage("language_code", languageCode).then(
          (_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const VRChatMobile(),
              ),
              (_) => false,
            );
          },
        );
      },
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
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ),
                      builder: (BuildContext context) => SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            _changeLocaleDialogOption(context, 'English', 'en'),
                            _changeLocaleDialogOption(context, '日本語', 'ja'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: theme,
                    title: Text(AppLocalizations.of(context)!.darkTheme),
                    subtitle: Text("${AppLocalizations.of(context)!.darkThemeDetails1}\n${AppLocalizations.of(context)!.darkThemeDetails2}"),
                    onChanged: _changeSwitchTheme,
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
