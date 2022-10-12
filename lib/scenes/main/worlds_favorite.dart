// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/sort/worlds_favorite.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;

  const VRChatMobileWorldsFavorite({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = appConfig.gridConfigList.favoriteWorlds;
  GridModalConfig gridConfig = GridModalConfig();
  SortMode sortedModeCache = SortMode.normal;
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    textStream(
      context,
    );

    if (config.sortMode != sortedModeCache) {
      for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
        sortWorlds(config, favoriteWorld.list);
      }
      sortedModeCache = config.sortMode;
    }
    if (config.descending != sortedDescendCache) {
      for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
        favoriteWorld.list.reversed.toList();
        sortedDescendCache = config.descending;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteWorlds),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, setState, config, gridConfig),
          ),
        ],
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) ...[
                Text(favoriteWorld.group.displayName),
                () {
                  switch (config.displayMode) {
                    case DisplayMode.normal:
                      return extractionWorldDefault(context, config, setState, favoriteWorld.list);
                    case DisplayMode.simple:
                      return extractionWorldSimple(context, config, setState, favoriteWorld.list);
                    case DisplayMode.textOnly:
                      return extractionWorldSimple(context, config, setState, favoriteWorld.list);
                  }
                }(),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
