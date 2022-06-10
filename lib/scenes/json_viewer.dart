// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class VRChatMobileJsonViewer extends StatefulWidget {
  final dynamic obj;
  const VRChatMobileJsonViewer({Key? key, required this.obj}) : super(key: key);

  @override
  State<VRChatMobileJsonViewer> createState() => _JsonViewerPageState();
}

class _JsonViewerPageState extends State<VRChatMobileJsonViewer> {
  String theme = "light";
  _JsonViewerPageState() {
    getStorage("theme_brightness").then((response) {
      setState(() => theme = response ?? "light");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.jsonViewer),
          actions: [clipboardShare(context, jsonEncode(widget.obj))],
        ),
        drawer: drawr(context),
        body: Container(
          color: theme == "dark" ? Colors.black : Colors.white,
          child: SafeArea(
              child: ListView(children: [
            JsonViewer(widget.obj),
          ])),
        ));
  }
}
