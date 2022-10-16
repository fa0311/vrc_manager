// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> confirm(BuildContext context, String title, String child) async {
  bool response = false;
  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            onPressed: () {
              response = true;
              Navigator.pop(context);
            },
            child: Text(child),
          ),
        ],
      );
    },
  );
  return response;
}
