// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/url_parser.dart';

textStream({required BuildContext context, required bool forceExternal}) async* {
  if (Platform.isAndroid || Platform.isIOS) {
    await for (String text in ReceiveSharingIntent.getTextStream()) {
      Widget? value = await urlParser(url: Uri.parse(text), forceExternal: forceExternal);
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => value),
        );
      }
    }
  }
}
