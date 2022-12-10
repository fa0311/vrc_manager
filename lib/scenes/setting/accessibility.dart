// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/locale.dart';
import 'package:vrc_manager/widgets/modal/theme.dart';

class VRChatMobileSettingsAccessibility extends ConsumerWidget {
  const VRChatMobileSettingsAccessibility({Key? key}) : super(key: key);

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
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(ref.read(languageCodeProvider).text),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const LocaleModal(),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(ref.read(themeBrightnessProvider).toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => ThemeBrightnessModal(themeBrightnessProvider),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.theme),
                  subtitle: Text(ref.read(darkThemeBrightnessProvider).toLocalization(context)),
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => ThemeBrightnessModal(darkThemeBrightnessProvider),
                  ),
                ),
                SwitchListTile(
                  value: ref.read(dontShowErrorDialogProvider),
                  title: Text(AppLocalizations.of(context)!.dontShowErrorDialog),
                  subtitle: Text(AppLocalizations.of(context)!.dontShowErrorDialogDetails),
                  onChanged: (bool e) => ref.read(dontShowErrorDialogProvider.notifier).set(e),
                ),
                if (!Platform.isWindows) ...[
                  SwitchListTile(
                    value: ref.read(forceExternalBrowserProvider),
                    title: Text(AppLocalizations.of(context)!.forceExternalBrowser),
                    subtitle: Text(AppLocalizations.of(context)!.forceExternalBrowserDetails),
                    onChanged: (bool e) => ref.read(forceExternalBrowserProvider.notifier).set(e),
                  )
                ],
                SwitchListTile(
                  value: ref.read(debugModeProvider),
                  title: Text(AppLocalizations.of(context)!.debugMode),
                  onChanged: (bool e) => ref.read(debugModeProvider.notifier).set(e),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
