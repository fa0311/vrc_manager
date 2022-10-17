// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/main.dart';

Future showLocaleModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) => Column(
          children: <Widget>[
            for (LanguageCode value in LanguageCode.values)
              ListTile(
                title: Text(value.text),
                trailing: appConfig.languageCode == value ? const Icon(Icons.check) : null,
                subtitle: Text(
                  AppLocalizations.of(context)!.translatorDetails(lookupAppLocalizations(
                    Locale(value.name, ""),
                  ).contributor),
                ),
                onTap: () {
                  appConfig.setLanguageCode(value);
                  appConfig.rootSetState(() {});
                },
              ),
          ],
        ),
      ),
    ),
  );
}
