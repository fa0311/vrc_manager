// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';

abstract class ConsumerGridWidget extends ConsumerWidget {
  final GridModalConfigType id;
  const ConsumerGridWidget({super.key, required this.id});

  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Container();
  }

  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Container();
  }

  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return Container();
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
