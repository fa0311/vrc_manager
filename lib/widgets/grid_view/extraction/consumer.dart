// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/storage/grid_modal.dart';

abstract class ConsumerGridWidget extends ConsumerWidget {
  final GridConfigId id;
  const ConsumerGridWidget({super.key, required this.id});

  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Column();
  }

  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Column();
  }

  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Column();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GridConfigNotifier config = ref.watch(gridConfigProvider(id));

    switch (config.displayMode) {
      case DisplayMode.normal:
        return normal(context, ref, config);
      case DisplayMode.simple:
        return simple(context, ref, config);
      case DisplayMode.textOnly:
        return textOnly(context, ref, config);
    }
  }
}
