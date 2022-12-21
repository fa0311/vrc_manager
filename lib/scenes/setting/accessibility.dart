// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/config_modal/theme.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileSettingsAccessibility extends ConsumerWidget {
  const VRChatMobileSettingsAccessibility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
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
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(accessibilityConfig.themeBrightness.toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const ThemeBrightnessModal(
                      dark: false,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(accessibilityConfig.darkThemeBrightness.toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const ThemeBrightnessModal(dark: true),
                  ),
                ),
                SwitchListTile(
                    value: accessibilityConfig.dontShowErrorDialog,
                    title: Text(AppLocalizations.of(context)!.dontShowErrorDialog),
                    subtitle: Text(AppLocalizations.of(context)!.dontShowErrorDialogDetails),
                    onChanged: (bool e) => accessibilityConfig.setDontShowErrorDialog(e)),
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
