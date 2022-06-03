import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

PopupMenuButton share(String url) {
  return PopupMenuButton(
    icon: const Icon(Icons.share),
    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.share),
              title: const Text('共有'),
              onTap: () {
                Share.share(url);
                Navigator.pop(context);
              })),
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('コピー'),
              onTap: () async {
                final data = ClipboardData(text: url);
                await Clipboard.setData(data).then((value) => Navigator.pop(context));
              })),
      PopupMenuItem(
          child: ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('ブラウザで開く'),
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              })),
    ],
  );
}
