// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class VRChatMobileJsonViewer extends StatefulWidget {
  final dynamic obj;
  final AppConfig appConfig;

  const VRChatMobileJsonViewer(this.appConfig, {Key? key, required this.obj}) : super(key: key);

  @override
  State<VRChatMobileJsonViewer> createState() => _JsonViewerPageState();
}

class _JsonViewerPageState extends State<VRChatMobileJsonViewer> {
  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.jsonViewer),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => modalBottom(context, [copyListTileWidget(context, jsonEncode(widget.obj))]),
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          child: ListView(
            children: [
              JsonViewer(widget.obj),
            ],
          ),
        ),
      ),
    );
  }
}
