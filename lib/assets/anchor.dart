// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/storage/accessibility.dart';

// Project imports:
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';

class TextToAnchor extends ConsumerWidget {
  final String text;
  const TextToAnchor({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);

    return RichText(
      text: TextSpan(
        children: [
          for (String line in text.split('\n')) ...[
            ...() {
              Match? match;
              String? text = () {
                match = RegExp(r'^(Twitter|twitter|TWITTER)([:˸：\s]{0,3})([@＠\s]{0,3})([0-9０-９a-zA-Z_]{1,15})$').firstMatch(line);
                if (match != null) return "https://twitter.com/${match!.group(match!.groupCount)}";
                match = RegExp(r'^(Github|github|GITHUB)([:˸：\s]{1,3})([0-9０-９a-zA-Z_]{1,38})$').firstMatch(line);
                if (match != null) return "https://github.com/${match!.group(match!.groupCount)}";
                match = RegExp(r'^(https?[:˸][/⁄]{2}.+)$').firstMatch(line);
                if (match != null) return "${match!.group(match!.groupCount)}".replaceAll("⁄", "/").replaceAll("˸", ":").replaceAll("․", ".");
                match = RegExp(r'^(Discord|discord|DISCORD)([:˸：\s]{1,3})(.{1,16}[#＃][0-9０-９]{4})$').firstMatch(line);
                if (match != null) return "${match!.group(match!.groupCount)}".replaceAll("＃", "#");
              }();
              if (match != null) {
                late int timeStamp = 0;
                if (match!.groupCount == 1) {
                  return [
                    TextSpan(
                      text: "${match!.group(1)}\n",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: LongPressGestureRecognizer()
                        ..onLongPressDown = ((details) => timeStamp = DateTime.now().millisecondsSinceEpoch)
                        ..onLongPress = () {
                          if (Uri.tryParse(text!) != null) {
                            showModalBottomSheetStatelessWidget(
                              context: context,
                              builder: () => ShareUrlListTile(url: Uri.parse(text)),
                            );
                          }
                        }
                        ..onLongPressCancel = () async {
                          if (DateTime.now().millisecondsSinceEpoch - timeStamp < 500) {
                            if (Uri.tryParse(text!) == null) {
                              copyToClipboard(context, text);
                            } else {
                              Widget? value = await openInBrowser(
                                url: Uri.parse(text),
                                forceExternal: accessibilityConfig.forceExternalBrowser,
                              );
                              if (value != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => value),
                                );
                              }
                            }
                          }
                        },
                    )
                  ];
                } else {
                  return [
                    TextSpan(text: "${match!.group(1)}${match!.group(2)}"),
                    TextSpan(
                      text: "${[for (int i = 3; i <= match!.groupCount; i++) match!.group(i)!].join()}\n",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: LongPressGestureRecognizer()
                        ..onLongPressDown = ((details) => timeStamp = DateTime.now().millisecondsSinceEpoch)
                        ..onLongPress = () {
                          if (Uri.tryParse(text!) != null) {
                            showModalBottomSheetStatelessWidget(
                              context: context,
                              builder: () => ShareUrlListTile(url: Uri.parse(text)),
                            );
                          }
                        }
                        ..onLongPressCancel = () async {
                          if (DateTime.now().millisecondsSinceEpoch - timeStamp < 500) {
                            if (Uri.tryParse(text!) == null) {
                              copyToClipboard(context, text);
                            } else {
                              Widget? value = await openInBrowser(
                                url: Uri.parse(text),
                                forceExternal: accessibilityConfig.forceExternalBrowser,
                              );
                              if (value != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => value),
                                );
                              }
                            }
                          }
                        },
                    )
                  ];
                }
              }
              return [TextSpan(text: "$line\n")];
            }(),
          ],
        ],
        style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),
      ),
    );
  }
}
