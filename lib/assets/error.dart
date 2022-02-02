import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void error(context, String text, {String log = ""}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("エラーが発生しました"),
          content: Text(text),
          actions: [
            if (log.isNotEmpty)
              TextButton(
                child: const Text("報告"),
                onPressed: () async {
                  _launchURL() async {
                    if (await canLaunch("https://github.com/fa0311/vrchat_mobile_client/issues/new")) {
                      await launch("https://github.com/fa0311/vrchat_mobile_client/issues/new");
                    }
                  }

                  final data = ClipboardData(text: log);
                  await Clipboard.setData(data);
                  _launchURL();
                },
              ),
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      });
}
