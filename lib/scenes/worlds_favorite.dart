// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/data_class.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/sort/worlds_favorite.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/modal.dart';
import 'package:vrchat_mobile_client/widgets/template.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;
  final AppConfig appConfig;

  const VRChatMobileWorldsFavorite(this.appConfig, {Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.appConfig.gridConfigList.favoriteWorlds;
  GridModalConfig gridConfig = GridModalConfig();
  String sortedModeCache = "default";
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    gridConfig.url = "https://vrchat.com/home/worlds";
    gridConfig.sort?.updatedDate = true;
    gridConfig.sort?.labsPublicationDate = true;
    gridConfig.sort?.heat = true;
    gridConfig.sort?.capacity = true;
    gridConfig.sort?.occupants = true;
  }

  GridView extractionDefault(List<VRChatFavoriteWorld> favoriteWorld) {
    return renderGrid(
      context,
      width: 600,
      height: 130,
      children: [
        for (VRChatFavoriteWorld world in favoriteWorld)
          () {
            return genericTemplate(
              context,
              widget.appConfig,
              imageUrl: world.thumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
                  )),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    world.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1,
                    ),
                  ),
                ),
              ],
            );
          }(),
      ],
    );
  }

  GridView extractionSimple(List<VRChatFavoriteWorld> favoriteWorld) {
    return renderGrid(
      context,
      width: 320,
      height: 64,
      children: [
        for (VRChatFavoriteWorld world in favoriteWorld)
          () {
            return genericTemplate(
              context,
              widget.appConfig,
              imageUrl: world.thumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
                  )),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    world.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ),
              ],
              stack: [
                SizedBox(
                  height: 17,
                  width: 17,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 15,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(0),
                  onPressed: () => vrhatLoginSession.deleteFavorites(world.favoriteId).then((response) {
                    setState(() => favoriteWorld.remove(world));
                  }).catchError((status) {
                    apiError(context, appConfig, status);
                  }),
                  icon: const Icon(Icons.delete),
                ),
              ],
            );
          }(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);

    if (config.sort != sortedModeCache) {
      for (FavoriteWorld favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) {
        sortFavoriteWorlds(config, favoriteWorld.list);
      }
      sortedModeCache = config.sort;
    }
    if (config.descending != sortedDescendCache) {
      for (FavoriteWorld favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) {
        favoriteWorld.list = favoriteWorld.list.reversed.toList();
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
              if (config.displayMode == "normal")
                for (FavoriteWorld favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) extractionDefault(favoriteWorld.list),
              if (config.displayMode == "simple")
                for (FavoriteWorld favoriteWorld in widget.appConfig.loggedAccount?.favoriteWorld ?? []) extractionSimple(favoriteWorld.list),
            ]),
          ),
        ),
      ),
    );
  }
}
