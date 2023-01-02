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
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/scenes/web/web_view.dart';

Future<Widget?> openInBrowser({required Uri url, required bool forceExternal}) async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (!forceExternal || url.host == VRChatAssets.vrchat.host) {
      return VRChatMobileWebView(initUrl: url);
    } else {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  } else {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
  return null;
}

Future copyToClipboard(BuildContext context, String text) async {
  final ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
  }
}
