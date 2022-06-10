// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

error(BuildContext context, String text, {String log = ""}) {
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
                onPressed: () async {
                  _launchURL() async {
                    if (await canLaunchUrl(Uri.parse("https://github.com/fa0311/vrchat_mobile_client/issues/new"))) {
                      await launchUrl(Uri.parse("https://github.com/fa0311/vrchat_mobile_client/issues/new"));
                    }
                  }

                  final data = ClipboardData(text: log);
                  await Clipboard.setData(data);
                  _launchURL();
                },
              ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      });
}
