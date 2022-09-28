// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/scenes/world.dart';
import 'package:vrc_manager/widgets/world.dart';

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
    if (displayMode == "simple") simpleAdd(world);
    if (displayMode == "text_only") textOnlyAdd(world);
    return children;
  }

  defaultAdd(VRChatWorld world) {
    children.add(simpleWorldDescription(context, world));
  }

  simpleAdd(VRChatWorld world) {
    children.add(simpleWorldDescriptionHalf(context, world));
  }

  textOnlyAdd(VRChatWorld world) {
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(5.0),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(world.name, style: const TextStyle(fontSize: 16)),
                Container(width: 15),
                if (world.description != null) Text(world.description!, style: const TextStyle(fontSize: 12)),
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
    if (displayMode == "simple") {
      height = 70;
      wrap = 320;
    }
    if (displayMode == "text_only") {
      height = 41;
      wrap = 400;
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
    if (displayMode == "simple") simpleAdd(world);
    if (displayMode == "text_only") textOnlyAdd(world);
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

  simpleAdd(VRChatFavoriteWorld world) {
    children.add(
      Card(
        elevation: 20.0,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
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
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: world.thumbnailImageUrl,
                        fit: BoxFit.fitWidth,
                        progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                          width: 50.0,
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 50.0,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  height: 1,
                                ),
                              ),
                            ),
                            if (descriptionMap[world.id] != null)
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  descriptionMap[world.id]!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          ],
        ),
      ),
    );
  }

  textOnlyAdd(VRChatFavoriteWorld world) {
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(5.0),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  child: IconButton(
                    iconSize: 20,
                    padding: const EdgeInsets.all(0),
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
                Text(world.name, style: const TextStyle(fontSize: 16)),
                Container(width: 15),
                if (descriptionMap[world.id] != null) Text(descriptionMap[world.id]!, style: const TextStyle(fontSize: 12)),
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
    if (displayMode == "simple") {
      height = 70;
      wrap = 320;
    }
    if (displayMode == "text_only") {
      height = 41;
      wrap = 400;
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
