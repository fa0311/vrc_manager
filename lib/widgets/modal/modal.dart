// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

RoundedRectangleBorder getGridShape() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  );
}

final gridModalProvider = StateProvider<GridModalConfig>((ref) {
  CurrentIndex currentIndex = ref.watch(currentIndexProvider);
  ref.watch(vrchatMobileSearchCounterProvider);
  SearchMode searchingMode = ref.watch(vrchatMobileSearchModeProvider);
  String searchingText = ref.read(searchBoxControllerProvider).text;

  switch (currentIndex) {
    case CurrentIndex.online:
      ref.read(gridConfigIdProvider.notifier).state = GridConfigId.onlineFriends;
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/locations")
        ..joinable = true
        ..worldDetails = true
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.friendsInInstance,
          SortMode.lastLogin,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case CurrentIndex.offline:
      ref.read(gridConfigIdProvider.notifier).state = GridConfigId.offlineFriends;
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/locations")
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.lastLogin,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case CurrentIndex.notify:
      ref.read(gridConfigIdProvider.notifier).state = GridConfigId.friendsRequest;
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/messages")
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case CurrentIndex.search:
      switch (searchingMode) {
        case SearchMode.users:
          ref.read(gridConfigIdProvider.notifier).state = GridConfigId.searchUsers;
          return GridModalConfig()
            ..url = Uri.https("vrchat.com", "/home/search/$searchingText")
            ..displayMode = [
              DisplayMode.normal,
              DisplayMode.simple,
              DisplayMode.textOnly,
            ]
            ..sortMode = [
              SortMode.normal,
              SortMode.name,
            ];
        case SearchMode.worlds:
          ref.read(gridConfigIdProvider.notifier).state = GridConfigId.searchWorlds;
          return GridModalConfig()
            ..url = Uri.https("vrchat.com", "/home/search/$searchingText")
            ..displayMode = [
              DisplayMode.normal,
              DisplayMode.simple,
              DisplayMode.textOnly,
            ]
            ..sortMode = [
              SortMode.normal,
              SortMode.name,
              SortMode.updatedDate,
              SortMode.labsPublicationDate,
              SortMode.heat,
              SortMode.capacity,
              SortMode.occupants,
            ];
      }
    case CurrentIndex.favorite:
      ref.read(gridConfigIdProvider.notifier).state = GridConfigId.favoriteWorlds;
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/worlds")
        ..removeButton = true
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ]
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.updatedDate,
          SortMode.labsPublicationDate,
          SortMode.heat,
          SortMode.capacity,
          SortMode.occupants,
        ];
  }
});

class GridModal extends ConsumerWidget {
  const GridModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    GridModalConfig gridModalConfig = ref.watch(gridModalProvider);
    return config.when(
      loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (config) {
        return Column(
          children: <Widget>[
            if (gridModalConfig.sortMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort),
                subtitle: Text(config.sortMode.toLocalization(context)),
                onTap: () => showModalBottomSheetConsumerWidget(
                  context: context,
                  builder: () => const GridSortModal(),
                ),
              ),
            if (gridModalConfig.displayMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.display),
                subtitle: Text(config.displayMode.toLocalization(context)),
                onTap: () => showModalBottomSheetConsumerWidget(
                  context: context,
                  builder: () => const GridDisplayModeModal(),
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
                  onChanged: (bool e) => config.setRemoveButton(e)),
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
      },
    );
  }
}

class GridSortModal extends ConsumerWidget {
  const GridSortModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    GridModalConfig gridModalConfig = ref.watch(gridModalProvider);
    return SingleChildScrollView(
      child: config.when(
        loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
        data: (config) {
          return Column(
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
          );
        },
      ),
    );
  }
}

class GridDisplayModeModal extends ConsumerWidget {
  const GridDisplayModeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GridConfigNotifier> config = ref.watch(gridConfigProvider);
    GridModalConfig gridModalConfig = ref.watch(gridModalProvider);
    return SingleChildScrollView(
      child: config.when(
        loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
        data: (config) {
          return Column(
            children: <Widget>[
              for (DisplayMode display in gridModalConfig.displayMode)
                ListTile(
                  title: Text(display.toLocalization(context)),
                  trailing: config.displayMode == display ? const Icon(Icons.check) : null,
                  onTap: () => config.setDisplayMode(display),
                ),
              SwitchListTile(
                value: config.descending,
                title: Text(AppLocalizations.of(context)!.descending),
                onChanged: (bool e) => config.setDescending(e),
              ),
            ],
          );
        },
      ),
    );
  }
}
