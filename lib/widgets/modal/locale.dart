// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/l10n/code.dart';

Future showLocaleModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Consumer(
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
      ),
    ),
  );
}
