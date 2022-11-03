// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';

class VRChatMobileWorldsFavorite extends ConsumerWidget {
  const VRChatMobileWorldsFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);

    late GridConfig config = appConfig.gridConfigList.favoriteWorlds;
    late SortData sortData = SortData(config);
    GridModalConfig gridConfig = GridModalConfig();

    gridConfig.url = "https://vrchat.com/home/worlds";
    gridConfig.removeButton = true;
    gridConfig.displayMode = [
      DisplayMode.normal,
      DisplayMode.simple,
      DisplayMode.textOnly,
    ];
    gridConfig.sortMode = [
      SortMode.normal,
      SortMode.name,
      SortMode.updatedDate,
      SortMode.labsPublicationDate,
      SortMode.heat,
      SortMode.capacity,
      SortMode.occupants,
    ];

    for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
      sortData.worlds(favoriteWorld.list);
    }

    return SingleChildScrollView(
      child: Column(children: [
        for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? [])
          if (favoriteWorld.list.isNotEmpty) ...[
            Text(favoriteWorld.group.displayName),
            () {
              switch (config.displayMode) {
                case DisplayMode.normal:
                  return extractionWorldDefault(context, config, favoriteWorld.list);
                case DisplayMode.simple:
                  return extractionWorldSimple(context, config, favoriteWorld.list);
                case DisplayMode.textOnly:
                  return extractionWorldSimple(context, config, favoriteWorld.list);
              }
            }(),
          ],
      ]),
    );
  }
}
