// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:vrc_manager/scenes/web/web_view.dart';

Future openInBrowser(BuildContext context, Uri url, {bool forceExternal = false}) async {
  if (!forceExternal && (Platform.isAndroid || Platform.isIOS)) {
    if (url.host != "vrchat.com") {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWebView(initUrl: url),
        ),
      );
    }
  } else {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}

Future copyToClipboard(BuildContext context, String text) async {
  final ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
  if (Platform.isAndroid || Platform.isIOS) {
    /*
    * To be fixed in the next stable version.
    * if(context.mounted)
    */
    // ignore: use_build_context_synchronously
    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
  }
}
