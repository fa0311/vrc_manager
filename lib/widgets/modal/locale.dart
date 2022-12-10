// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/l10n/code.dart';
import 'package:vrc_manager/widgets/modal.dart';

Future showLocaleModal(BuildContext context) {
  return showModalBottomSheetStateless(
    context: context,
    builder: (context, ref, _) {
      final languageCode = ref.watch(languageCodeProvider);

      return Column(
        children: <Widget>[
          for (LanguageCode value in LanguageCode.values)
            ListTile(
              title: Text(value.text),
              trailing: languageCode == value ? const Icon(Icons.check) : null,
              subtitle: Text(
                AppLocalizations.of(context)!.translatorDetails(lookupAppLocalizations(
                  Locale(value.name, ""),
                ).contributor),
              ),
              onTap: () {
                ref.read(languageCodeProvider.notifier).set(value);
              },
            ),
        ],
      );
    },
  );
}
