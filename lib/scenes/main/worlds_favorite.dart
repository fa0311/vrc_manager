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
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;
  final AppConfig appConfig;

  const VRChatMobileWorldsFavorite(this.appConfig, {Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.appConfig.gridConfigList.favoriteWorlds;
  GridModalConfig gridConfig = GridModalConfig();
  String sortedModeCache = "default";
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    gridConfig.url = "https://vrchat.com/home/worlds";
    gridConfig.removeButton = true;
    gridConfig.sort?.updatedDate = true;
    gridConfig.sort?.labsPublicationDate = true;
    gridConfig.sort?.heat = true;
    gridConfig.sort?.capacity = true;
    gridConfig.sort?.occupants = true;
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);

    if (config.sort != sortedModeCache) {
      for (FavoriteWorldData favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) {
        sortWorlds(config, favoriteWorld.list);
      }
      sortedModeCache = config.sort;
    }
    if (config.descending != sortedDescendCache) {
      for (FavoriteWorldData favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) {
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
            onPressed: () => gridModal(context, widget.appConfig, setState, config, gridConfig),
          ),
        ],
      ),
      drawer: drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              for (FavoriteWorldData favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) ...[
                Text(favoriteWorld.group.displayName),
                if (config.displayMode == "normal") extractionWorldDefault(context, config, setState, favoriteWorld.list),
                if (config.displayMode == "simple") extractionWorldSimple(context, config, setState, favoriteWorld.list),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
