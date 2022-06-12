// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/widgets/share.dart';

void error(BuildContext context, String text, {String log = ""}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.errorDialog),
        content: Text(text),
        actions: [
          if (log.isNotEmpty)
            TextButton(
                child: Text(AppLocalizations.of(context)!.report),
                onPressed: () {
                  final data = ClipboardData(text: log);
                  Clipboard.setData(data).then(((_) => openInBrowser(context, "https://github.com/fa0311/vrchat_mobile_client/issues/new")));
                }),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
