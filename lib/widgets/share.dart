// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/web/web_view.dart';

Future openInBrowser(BuildContext context, String url, {bool forceExternal = false}) async {
  if (!forceExternal && (Platform.isAndroid || Platform.isIOS)) {
    if (appConfig.forceExternalBrowser && Uri.parse(url).host != "vrchat.com") {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWebView(url: url),
        ),
      );
    }
  } else {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
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
