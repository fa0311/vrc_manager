import 'dart:io';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';

textStream(context) {
  if (Platform.isAndroid || Platform.isIOS) {
    ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        urlParser(context, value);
      },
    );
  }
}
