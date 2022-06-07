// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

PopupMenuButton share(String url) {
  return PopupMenuButton(
    icon: const Icon(Icons.share),
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.share),
              onTap: () {
                Share.share(url);
                Navigator.pop(context);
              })),
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.copy),
              title: Text(AppLocalizations.of(context)!.copy),
              onTap: () async {
                final data = ClipboardData(text: url);
                await Clipboard.setData(data).then((value) => Navigator.pop(context));
              })),
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(AppLocalizations.of(context)!.openInBrowser),
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              })),
    ],
  );
}
