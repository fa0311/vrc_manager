import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    if (await canLaunchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl))) {
                      await launchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl));
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
