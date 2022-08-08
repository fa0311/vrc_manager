// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';

ListTile changeLocaleDialogOption(BuildContext context, String title, String languageCode) {
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

showLocaleModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          changeLocaleDialogOption(context, 'English', 'en'),
          changeLocaleDialogOption(context, '日本語', 'ja'),
          changeLocaleDialogOption(context, 'español', 'es'),
          changeLocaleDialogOption(context, 'Português', 'pt'),
          changeLocaleDialogOption(context, 'русский', 'ru'),
          changeLocaleDialogOption(context, 'ไทย', 'th'),
          changeLocaleDialogOption(context, '简体中文', 'zh'),
        ],
      ),
    ),
  );
}
