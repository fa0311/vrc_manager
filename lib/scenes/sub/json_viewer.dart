// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';

class VRChatMobileJsonViewer extends ConsumerWidget {
  final dynamic content;
  const VRChatMobileJsonViewer({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    textStream(context: context, forceExternal: accessibilityConfig.forceExternalBrowser);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.jsonViewer),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => Column(children: [CopyListTileWidget(text: jsonEncode(content))]),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: SafeArea(
          child: ListView(
            children: [
              JsonViewer(content),
            ],
          ),
        ),
      ),
    );
  }
}
