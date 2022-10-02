// Flutter imports:

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
import 'package:vrchat_mobile_client/widgets/legacy_users.dart';
import 'package:vrchat_mobile_client/widgets/legacy_worlds.dart';

class VRChatSearch extends StatefulWidget {
  final AppConfig appConfig;

  const VRChatSearch(this.appConfig, {Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

class _SearchState extends State<VRChatSearch> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  TextEditingController searchBoxController = TextEditingController();
  FocusNode searchBoxFocusNode = FocusNode();
  String searchMode = "users";
  String searchModeSelected = "users";
  int offset = 0;
  Worlds dataColumnWorlds = Worlds();
  Users dataColumnUsers = Users();
  Widget body = Column(
    children: const [],
  );

  @override
  initState() {
    super.initState();
    List<Future> futureStorageList = [];
    futureStorageList.add(getStorage("search_users_display_mode").then(
      (response) {
        dataColumnUsers.displayMode = response ?? "normaldescription";
      },
    ));
    futureStorageList.add(getStorage("search_worlds_display_mode").then(
      (response) {
        dataColumnWorlds.displayMode = response ?? "normal";
      },
    ));
    futureStorageList.add(getStorage("search_mode").then(
      (response) {
        searchMode = response ?? "users";
        searchModeSelected = searchMode;
      },
    ));
    Future.wait(futureStorageList).then(((value) => setState(() {})));
  }

  searchModeModal(Function setStateBuilderParent) {
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
                title: Text(AppLocalizations.of(context)!.user),
                trailing: searchModeSelected == "users" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchModeSelected = "users");
                  setStateBuilderParent(() {});
                  setStorage("search_mode", searchModeSelected);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.world),
                trailing: searchModeSelected == "worlds" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchModeSelected = "worlds");
                  setStateBuilderParent(() {});
                  setStorage("search_mode", searchModeSelected);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> moreOver(String text) {
    setState(() {
      offset += 50;
    });
    searchBoxFocusNode.unfocus();
    if (searchMode == "worlds") {
      return vrhatLoginSession.searchWorlds(text, offset: offset - 50).then((List<VRChatLimitedWorld> worlds) {
        List<Future> futureList = [];
        for (VRChatLimitedWorld world in worlds) {
          futureList.add(vrhatLoginSession.worlds(world.id).then((VRChatWorld world) {
            dataColumnWorlds.add(world);
          }).catchError((status) {
            apiError(context, widget.appConfig, status);
          }));
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
          );
        });
      }).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
    } else if (searchMode == "users") {
      return vrhatLoginSession.searchUsers(text, offset: offset - 50).then((List<VRChatUser> users) {
        List<Future> futureList = [];
        for (VRChatUser user in users) {
          futureList.add(
            vrhatLoginSession.users(user.id).then((VRChatFriends user) {
              dataColumnUsers.userList.add(user);
            }).catchError((status) {
              apiError(context, widget.appConfig, status);
            }),
          );
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnUsers.render(children: dataColumnUsers.reload()),
          );
        });
      }).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
    }
    throw Exception();
  }

  displeyModeModalUser(Function setStateBuilderParent) {
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
                title: Text(AppLocalizations.of(context)!.normal),
                trailing: dataColumnUsers.displayMode == "normaldescription" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnUsers.displayMode = "normaldescription").then((value) {
                    setState(() => body = dataColumnUsers.render(
                          children: dataColumnUsers.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.simple),
                trailing: dataColumnUsers.displayMode == "simple_description" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnUsers.displayMode = "simple_description").then((value) {
                    setState(() => body = dataColumnUsers.render(
                          children: dataColumnUsers.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumnUsers.displayMode == "text_only_description" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnUsers.displayMode = "text_only_description").then((value) {
                    setState(() => body = dataColumnUsers.render(
                          children: dataColumnUsers.reload(),
                        ));
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
                title: Text(AppLocalizations.of(context)!.normal),
                trailing: dataColumnWorlds.displayMode == "normal" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnWorlds.displayMode = "normal").then((value) {
                    setState(() => body = dataColumnWorlds.render(
                          children: dataColumnWorlds.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.simple),
                trailing: dataColumnWorlds.displayMode == "simple" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnWorlds.displayMode = "simple").then((value) {
                    setState(() => body = dataColumnWorlds.render(
                          children: dataColumnWorlds.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumnWorlds.displayMode == "text_only" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_${searchMode}_display_mode", dataColumnWorlds.displayMode = "text_only").then((value) {
                    setState(() => body = dataColumnWorlds.render(
                          children: dataColumnWorlds.reload(),
                        ));
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
    textStream(context, widget.appConfig);
    dataColumnUsers.context = context;
    dataColumnUsers.appConfig = widget.appConfig;
    dataColumnUsers.vrhatLoginSession = vrhatLoginSession;
    dataColumnWorlds.context = context;
    dataColumnWorlds.appConfig = widget.appConfig;
    dataColumnWorlds.vrhatLoginSession = vrhatLoginSession;

    const selectedTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
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
                      if (searchMode == "users")
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.display),
                          subtitle: {
                                "normaldescription": Text(AppLocalizations.of(context)!.normal),
                                "simple_description": Text(AppLocalizations.of(context)!.simple),
                                "text_only_description": Text(AppLocalizations.of(context)!.textOnly),
                              }[dataColumnUsers.displayMode] ??
                              Text(AppLocalizations.of(context)!.sortedByDefault),
                          onTap: () => setStateBuilder(() => displeyModeModalUser(setStateBuilder)),
                        ),
                      if (searchMode == "worlds")
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.display),
                          subtitle: {
                                "normal": Text(AppLocalizations.of(context)!.normal),
                                "simple": Text(AppLocalizations.of(context)!.simple),
                                "text_only": Text(AppLocalizations.of(context)!.textOnly),
                              }[dataColumnWorlds.displayMode] ??
                              Text(AppLocalizations.of(context)!.sortedByDefault),
                          onTap: () => setStateBuilder(() => displeyModeModalWorld(setStateBuilder)),
                        ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.openInBrowser),
                        onTap: () {
                          Navigator.pop(context);
                          openInBrowser(context, widget.appConfig, "https://vrchat.com/home/search/${searchBoxController.text}");
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
      drawer: drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
                  child: TextField(
                    controller: searchBoxController,
                    focusNode: searchBoxFocusNode,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          body = Column(
                            children: const [
                              Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                            ],
                          );
                          offset = 0;
                          searchMode = searchModeSelected;
                          dataColumnWorlds.worldList = [];
                          dataColumnUsers.userList = [];
                          moreOver(searchBoxController.text);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.type),
                        trailing: {
                              "users": Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                              "worlds": Text(AppLocalizations.of(context)!.world, style: selectedTextStyle),
                            }[searchModeSelected] ??
                            Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                        onTap: () => setState(() => searchModeModal(setState)),
                      ),
                    ],
                  ),
                ),
                body,
                if (dataColumnUsers.userList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(searchBoxController.text).then(
                            (_) => setState(
                              () => body = dataColumnUsers.render(children: dataColumnUsers.reload()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (dataColumnWorlds.worldList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(searchBoxController.text).then(
                            (_) => setState(
                              () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
