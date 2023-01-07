// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';

abstract class ConsumerGridWidget extends ConsumerWidget {
  final GridModalConfigType id;
  const ConsumerGridWidget({super.key, required this.id});

  List<Widget> normal(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style);

  List<Widget> simple(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style);

  List<Widget> textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GridConfigNotifier config = ref.watch(gridConfigProvider(id));

    switch (config.displayMode) {
      case DisplayMode.normal:
        final style = ConsumerGridStyle(
          title: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          details: const TextStyle(fontSize: 15),
        );
        return RenderGrid(
          width: 600,
          height: config.worldDetails ? 235 : 130,
          children: normal(context, ref, config, style),
        );
      case DisplayMode.simple:
        final style = ConsumerGridStyle(
          title: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          details: const TextStyle(fontSize: 10),
        );
        return RenderGrid(
          width: 320,
          height: config.worldDetails ? 119 : 64,
          children: simple(context, ref, config, style),
        );
      case DisplayMode.textOnly:
        final style = ConsumerGridStyle(
          title: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          details: const TextStyle(fontSize: 10),
        );
        return RenderGrid(
          width: 200,
          height: config.worldDetails ? 27 : 20,
          children: textOnly(context, ref, config, style),
        );
    }
  }
}

class ConsumerGridStyle {
  final TextStyle title;
  final TextStyle details;
  ConsumerGridStyle({required this.title, required this.details});
}
