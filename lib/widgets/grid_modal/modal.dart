// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

class GridModal extends ConsumerWidget {
  final GridModalConfigType type;

  const GridModal({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String searchingText = ref.read(searchBoxControllerProvider).text;
    GridConfigNotifier config = ref.watch(gridConfigProvider(type));
    GridModalConfigData gridModalConfig = getGridModalConfig(type: type, text: searchingText);
    return Column(
      children: <Widget>[
        if (gridModalConfig.sortMode.isNotEmpty)
          ListTile(
            title: Text(AppLocalizations.of(context)!.sort),
            subtitle: Text(config.sortMode.toLocalization(context)),
            onTap: () => showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => GridSortModal(type: type),
            ),
          ),
        if (gridModalConfig.displayMode.isNotEmpty)
          ListTile(
            title: Text(AppLocalizations.of(context)!.display),
            subtitle: Text(config.displayMode.toLocalization(context)),
            onTap: () => showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => GridDisplayModeModal(type: type),
            ),
          ),
        if (gridModalConfig.joinable)
          SwitchListTile(
            value: config.joinable,
            title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
            onChanged: (bool e) => config.setJoinable(e),
          ),
        if (gridModalConfig.worldDetails)
          SwitchListTile(
            value: config.worldDetails,
            title: Text(AppLocalizations.of(context)!.worldDetails),
            onChanged: (bool e) => config.setWorldDetails(e),
          ),
        if (gridModalConfig.removeButton)
          SwitchListTile(
            value: config.removeButton,
            title: Text(AppLocalizations.of(context)!.worldUnfavoriteButton),
            onChanged: (bool e) => config.setRemoveButton(e),
          ),
        if (gridModalConfig.url != null)
          ListTile(
            title: Text(AppLocalizations.of(context)!.openInBrowser),
            onTap: () {
              Navigator.pop(context);
              openInBrowser(context, gridModalConfig.url!);
            },
          ),
      ],
    );
  }
}

class GridSortModal extends ConsumerWidget {
  final GridModalConfigType type;

  const GridSortModal({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(vrchatMobileSearchCounterProvider);
    String searchingText = ref.read(searchBoxControllerProvider).text;
    GridConfigNotifier config = ref.watch(gridConfigProvider(type));
    GridModalConfigData gridModalConfig = getGridModalConfig(type: type, text: searchingText);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (SortMode sort in gridModalConfig.sortMode)
            ListTile(
                title: Text(sort.toLocalization(context)),
                trailing: config.sortMode == sort ? const Icon(Icons.check) : null,
                onTap: () => config.setSort(sort)),
          SwitchListTile(
            value: config.descending,
            title: Text(AppLocalizations.of(context)!.descending),
            onChanged: (bool e) => config.setDescending(e),
          ),
        ],
      ),
    );
  }
}

class GridDisplayModeModal extends ConsumerWidget {
  final GridModalConfigType type;

  const GridDisplayModeModal({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(vrchatMobileSearchCounterProvider);
    String text = ref.read(searchBoxControllerProvider).text;
    GridConfigNotifier config = ref.watch(gridConfigProvider(type));
    GridModalConfigData gridModalConfig = getGridModalConfig(type: type, text: text);

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        for (DisplayMode display in gridModalConfig.displayMode)
          ListTile(
            title: Text(display.toLocalization(context)),
            trailing: config.displayMode == display ? const Icon(Icons.check) : null,
            onTap: () => config.setDisplayMode(display),
          ),
      ],
    ));
  }
}
