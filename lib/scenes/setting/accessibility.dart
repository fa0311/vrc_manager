// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/config_modal/theme.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileSettingsAccessibility extends ConsumerWidget {
  const VRChatMobileSettingsAccessibility({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
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
                  subtitle: Text(accessibilityConfig.languageCode.text),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const LocaleModal(),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.deviceLightTheme),
                  subtitle: Text(accessibilityConfig.themeBrightness.toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const ThemeBrightnessModal(dark: false),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.deviceDarkTheme),
                  subtitle: Text(accessibilityConfig.darkThemeBrightness.toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const ThemeBrightnessModal(dark: true),
                  ),
                ),
                if (!Platform.isWindows)
                  SwitchListTile(
                    value: accessibilityConfig.forceExternalBrowser,
                    title: Text(AppLocalizations.of(context)!.forceExternalBrowser),
                    subtitle: Text(AppLocalizations.of(context)!.forceExternalBrowserDetails),
                    onChanged: (bool e) => accessibilityConfig.setForceExternalBrowser(e),
                  ),
                SwitchListTile(
                  value: accessibilityConfig.debugMode,
                  title: Text(AppLocalizations.of(context)!.debugMode),
                  onChanged: (bool e) => accessibilityConfig.setDebugMode(e),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
