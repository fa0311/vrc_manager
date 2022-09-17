// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/worlds.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;
  final AppConfig appConfig;

  const VRChatMobileWorldsFavorite(this.appConfig, {Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  List<int> offset = [];
  List<FavoriteWorlds> dataColumn = [];

  List<Widget> bodyList = const [
    Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
  ];

  List<VRChatFavoriteGroup> favoriteList = [];

  @override
  initState() {
    super.initState();

    getStorage("worlds_favorite_display_mode").then((String? displayMode) {
      vrhatLoginSession.favoriteGroups("world", offset: 0).then((
        VRChatFavoriteGroupList response,
      ) {
        if (response.group.isEmpty) {
          setState(
            () => bodyList = [Text(AppLocalizations.of(context)!.none)],
          );
        }
        final List<Widget> children = [];
        for (VRChatFavoriteGroup list in response.group) {
          children.add(Column(
            children: <Widget>[
              Text(list.displayName),
            ],
          ));
        }
        bodyList = [];
        response.group.asMap().forEach((index, VRChatFavoriteGroup list) {
          offset.add(0);
          bodyList.add(Column(children: const [Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())]));
          dataColumn.add(FavoriteWorlds()
            ..context = context
            ..appConfig = widget.appConfig
            ..vrhatLoginSession = vrhatLoginSession
            ..displayMode = displayMode ?? "default");
          favoriteList.add(list);
          moreOver(index);
        });
      }).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
    });
  }

  bool canMoreOver(int index) {
    return (dataColumn[index].worldList.length == offset[index]);
  }

  moreOver(int index) {
    setState(() {
      offset[index] += 50;
    });
    vrhatLoginSession.favoritesWorlds(favoriteList[index].name, offset: offset[index] - 50).then((VRChatFavoriteWorldList worlds) {
      List<Future> futureList = [];
      for (VRChatFavoriteWorld world in worlds.world) {
        dataColumn[index].add(world);
        futureList.add(
          vrhatLoginSession.worlds(world.id).then((VRChatWorld world) {
            dataColumn[index].descriptionMap[world.id] = world.description;
          }).catchError((status) {
            apiError(context, widget.appConfig, status);
          }),
        );
      }
      Future.wait(futureList).then((value) {
        setState(
          () => reload(index),
        );
      });
    }).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
  }

  reload(int index) {
    setState(
      () => bodyList[index] = Column(
        children: [
          Text(favoriteList[index].displayName),
          dataColumn[index].render(children: dataColumn[index].reload()),
          if (canMoreOver(index))
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.readMore),
                    onPressed: () => moreOver(index),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  displeyModeModalWorld(Function setStateBuilderParent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.default_),
                trailing: dataColumn[0].displayMode == "default" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("worlds_favorite_display_mode", "default").then((value) {
                    for (FavoriteWorlds world in dataColumn) {
                      world.displayMode = "default";
                    }
                    setState(() => dataColumn.asMap().forEach((int i, _) => reload(i)));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.simple),
                trailing: dataColumn[0].displayMode == "simple" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("worlds_favorite_display_mode", "simple").then((value) {
                    for (FavoriteWorlds world in dataColumn) {
                      world.displayMode = "simple";
                    }
                    setState(() => dataColumn.asMap().forEach((int i, _) => reload(i)));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumn[0].displayMode == "text_only" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("worlds_favorite_display_mode", "text_only").then((value) {
                    for (FavoriteWorlds world in dataColumn) {
                      world.displayMode = "text_only";
                    }
                    setState(() => dataColumn.asMap().forEach((int i, _) => reload(i)));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(
      context,
      widget.appConfig,
    );
    dataColumn.asMap().forEach((index, FavoriteWorlds data) {
      data.button = () {
        reload(index);
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteWorlds),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, Function setStateBuilder) => SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.display),
                        subtitle: {
                              "default": Text(AppLocalizations.of(context)!.default_),
                              "simple": Text(AppLocalizations.of(context)!.simple),
                              "text_only": Text(AppLocalizations.of(context)!.textOnly),
                            }[dataColumn[0].displayMode] ??
                            Text(AppLocalizations.of(context)!.sortedByDefault),
                        onTap: () => setStateBuilder(() => displeyModeModalWorld(setStateBuilder)),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.openInBrowser),
                        onTap: () {
                          Navigator.pop(context);
                          openInBrowser(context, widget.appConfig, "https://vrchat.com/home/worlds");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: drawer(
        context,
        widget.appConfig,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: bodyList),
          ),
        ),
      ),
    );
  }
}
