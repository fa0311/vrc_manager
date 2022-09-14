// Dart imports:
import 'dart:io';

// Package imports:
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';

textStream(
  context,
  appConfig,
) {
  if (Platform.isAndroid || Platform.isIOS) {
    ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        urlParser(context, appConfig, value);
      },
    );
  }
}
