// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/l10n/code.dart';
import 'package:vrc_manager/storage/accessibility.dart';

class LocaleModal extends ConsumerWidget {
  const LocaleModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityConfig = ref.watch(accessibilityConfigProvider);

    return Column(
      children: <Widget>[
        for (LanguageCode value in LanguageCode.values)
          ListTile(
            title: Text(value.text),
            trailing: accessibilityConfig.languageCode == value ? const Icon(Icons.check) : null,
            subtitle: Text(
              AppLocalizations.of(context)!.translatorDetails(
                lookupAppLocalizations(
                  Locale(value.name, ""),
                ).contributor,
              ),
            ),
            onTap: () {
              accessibilityConfig.setLanguageCode(value);
            },
          ),
      ],
    );
  }
}
