// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

// Dart imports:

// Flutter imports:



class Worlds {
  List<Widget> children = [];
  late BuildContext context;
  List<VRChatWorld> worldList = [];
  String displayMode = "default";

  List<Widget> reload() {
    children = [];
    List<VRChatWorld> tempworldList = worldList;
    worldList = [];
    for (VRChatWorld world in tempworldList) {
      add(world);
    }
    return children;
  }

  List<Widget> add(VRChatWorld world) {
    worldList.add(world);
    if (displayMode == "default") defaultAdd(world);
    return children;
  }

  defaultAdd(VRChatWorld world) {
    children.add(simpleWorldDescription(context, world));
  }

  Widget render({required List<Widget> children}) {
    if (children.isEmpty) return Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]);
    double width = MediaQuery.of(context).size.width;
    int height = 0;
    int wrap = 0;
    if (displayMode == "default") {
      height = 120;
      wrap = 600;
    }

    return GridView.count(
      crossAxisCount: width ~/ wrap + 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: width / (width ~/ wrap + 1) / height,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

class WorldsLimited {
  List<Widget> children = [];
  late BuildContext context;
  List<VRChatLimitedWorld> worldList = [];
  String displayMode = "default";

  List<Widget> reload() {
    children = [];
    List<VRChatLimitedWorld> tempworldList = worldList;
    worldList = [];
    for (VRChatLimitedWorld world in tempworldList) {
      add(world);
    }
    return children;
  }

  List<Widget> add(VRChatLimitedWorld world) {
    worldList.add(world);
    if (displayMode == "default") defaultAdd(world);
    return children;
  }

  defaultAdd(VRChatLimitedWorld world) {
    children.add(simpleWorld(context, world));
  }

  Widget render({required List<Widget> children}) {
    if (children.isEmpty) return Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]);
    double width = MediaQuery.of(context).size.width;
    int height = 0;
    int wrap = 0;
    if (displayMode == "default") {
      height = 120;
      wrap = 600;
    }

    return GridView.count(
      crossAxisCount: width ~/ wrap + 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: width / (width ~/ wrap + 1) / height,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

class FavoriteWorlds {
  List<Widget> children = [];
  late BuildContext context;
  List<VRChatFavoriteWorld> worldList = [];
  Map<String, String?> descriptionMap = {};
  String displayMode = "default";
  Function button = () {};

  List<Widget> reload() {
    children = [];
    List<VRChatFavoriteWorld> tempworldList = worldList;
    worldList = [];
    for (VRChatFavoriteWorld world in tempworldList) {
      add(world);
    }
    return children;
  }

  List<Widget> add(VRChatFavoriteWorld world) {
    worldList.add(world);
    if (displayMode == "default") defaultAdd(world);
    return children;
  }

  defaultAdd(VRChatFavoriteWorld world) {
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                  ));
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: world.thumbnailImageUrl,
                    fit: BoxFit.fitWidth,
                    progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                      width: 100.0,
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 100.0,
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            world.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (descriptionMap[world.id] != null)
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              descriptionMap[world.id]!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      getLoginSession("login_session").then(
                        (cookie) => VRChatAPI(cookie: cookie ?? "").deleteFavorites(world.favoriteId).then((response) {
                          worldList.remove(world);
                          button();
                        }).catchError((status) {
                          apiError(context, status);
                        }),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget render({required List<Widget> children}) {
    if (children.isEmpty) return Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]);
    double width = MediaQuery.of(context).size.width;
    int height = 0;
    int wrap = 0;
    if (displayMode == "default") {
      height = 120;
      wrap = 600;
    }

    return GridView.count(
      crossAxisCount: width ~/ wrap + 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: width / (width ~/ wrap + 1) / height,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}