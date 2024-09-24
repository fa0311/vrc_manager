// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
// Project imports:
import 'package:vrc_manager/assets/flutter/url_parser.dart';

textStream({required BuildContext context, required bool forceExternal}) async {
  if (!Platform.isAndroid && !Platform.isIOS) return;
  await for (final file in FlutterSharingIntent().getMediaStream()) {
    for (final SharedFile sharedFile in file) {
      if (sharedFile.type == SharedMediaType.TEXT || sharedFile.type == SharedMediaType.URL) {
        String text = sharedFile.value!;
        Widget? value = await urlParser(url: Uri.parse(text), forceExternal: forceExternal);
        if (value == null) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => value));
      }
    }
  }
}

Future<String?> initTest() async {
  final sharedFile = await FlutterSharingIntent().getInitialSharing();
  for (final SharedFile sharedFile in sharedFile) {
    if (sharedFile.type == SharedMediaType.TEXT || sharedFile.type == SharedMediaType.URL) {
      String text = sharedFile.value!;
      return text;
    }
  }
  return null;
}
