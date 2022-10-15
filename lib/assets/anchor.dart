// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/widgets/share.dart';

List<InlineSpan> textToAnchor(BuildContext context, String text) {
  return [
    for (String line in text.split('\n')) ...[
      ...() {
        bool isUrl = true;
        Match? match;
        String? text = () {
          match = RegExp(r'^(Twitter|twitter|TWITTER)([:˸：\s]{0,3})([@＠\s]{0,3})([0-9０-９a-zA-Z_]{1,15})$').firstMatch(line);
          if (match != null) return "https://twitter.com/${match!.group(match!.groupCount)}";
          match = RegExp(r'^(Github|github|GITHUB)([:˸：\s]{1,3})([0-9０-９a-zA-Z_]{1,38})$').firstMatch(line);
          if (match != null) return "https://github.com/${match!.group(match!.groupCount)}";
          match = RegExp(r'^([0-9０-９a-zA-Z_]{2,16})([:˸：\s]{1,3})(https?[:˸][/⁄]{2}.+)$').firstMatch(line);
          if (match != null) return "https://twitter.com/${match!.group(match!.groupCount)}";
          isUrl = false;
          match = RegExp(r'^(Discord|discord|DISCORD)([:˸：\s]{1,3})(.{1,16}[#＃][0-9０-９]{4})$').firstMatch(line);
          if (match != null) return "${match!.group(match!.groupCount)}".replaceAll("＃", "#");
        }();
        if (match != null) {
          late int timeStamp = 0;
          return [
            TextSpan(text: "${match!.group(1)}${match!.group(2)}"),
            TextSpan(
                text: "${[for (int i = 3; i <= match!.groupCount; i++) match!.group(i)!].join()}\n",
                style: const TextStyle(color: Colors.blue),
                recognizer: LongPressGestureRecognizer()
                  ..onLongPressDown = ((details) => timeStamp = DateTime.now().millisecondsSinceEpoch)
                  ..onLongPress = () {
                    if (isUrl) modalBottom(context, shareUrlListTile(context, text!));
                  }
                  ..onLongPressCancel = () {
                    if (DateTime.now().millisecondsSinceEpoch - timeStamp < 500) {
                      if (isUrl) {
                        openInBrowser(context, text!);
                      } else {
                        copyToClipboard(context, text!);
                      }
                    }
                  })
          ];
        }
        return [TextSpan(text: "$line\n")];
      }(),
    ],
  ];
}
