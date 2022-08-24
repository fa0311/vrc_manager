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
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';
import 'package:vrchat_mobile_client/widgets/worlds.dart';

class VRChatSearch extends StatefulWidget {
  const VRChatSearch({Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

class _SearchState extends State<VRChatSearch> {
  TextEditingController searchBoxController = TextEditingController();
  FocusNode searchBoxFocusNode = FocusNode();
  String searchMode = "users";
  String searchModeSelected = "users";
  int offset = 0;
  String? cookie;
  Worlds dataColumnWorlds = Worlds();
  Users dataColumnUsers = Users();
  Widget body = Column(
    children: const [],
  );

  _SearchState() {
    List<Future> futureStorageList = [];
    futureStorageList.add(getLoginSession("login_session").then(
      (response) {
        cookie = response;
      },
    ));
    futureStorageList.add(getStorage("search_display_mode").then(
      (response) {
        dataColumnUsers.displayMode = response ?? "default_description";
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
      return VRChatAPI(cookie: cookie ?? "").searchWorlds(text, offset: offset - 50).then((VRChatLimitedWorldList worlds) {
        List<Future> futureList = [];
        for (VRChatLimitedWorld world in worlds.world) {
          futureList.add(VRChatAPI(cookie: cookie ?? "").worlds(world.id).then((VRChatWorld world) {
            dataColumnWorlds.add(world);
          }).catchError((status) {
            apiError(context, status);
          }));
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
          );
        });
      }).catchError((status) {
        apiError(context, status);
      });
    } else if (searchMode == "users") {
      return VRChatAPI(cookie: cookie ?? "").searchUsers(text, offset: offset - 50).then((VRChatUserLimitedList users) {
        List<Future> futureList = [];
        for (VRChatUserLimited user in users.users) {
          futureList.add(
            VRChatAPI(cookie: cookie ?? "").users(user.id).then((VRChatUser user) {
              dataColumnUsers.userList.add(user);
            }).catchError((status) {
              apiError(context, status);
            }),
          );
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnUsers.render(children: dataColumnUsers.reload()),
          );
        });
      }).catchError((status) {
        apiError(context, status);
      });
    }
    throw Exception();
  }

  displeyModeModal(Function setStateBuilderParent) {
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
                trailing: dataColumnUsers.displayMode == "default" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_display_mode", dataColumnUsers.displayMode = "default").then((value) {
                    setState(() => body = dataColumnUsers.render(
                          children: dataColumnUsers.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.simple),
                trailing: dataColumnUsers.displayMode == "simple" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_display_mode", dataColumnUsers.displayMode = "simple").then((value) {
                    setState(() => body = dataColumnUsers.render(
                          children: dataColumnUsers.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumnUsers.displayMode == "text_only" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("search_display_mode", dataColumnUsers.displayMode = "text_only").then((value) {
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

  @override
  Widget build(BuildContext context) {
    textStream(context);
    dataColumnUsers.context = context;
    dataColumnWorlds.context = context;

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
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.display),
                        subtitle: searchMode != "users"
                            ? Text(AppLocalizations.of(context)!.default_)
                            : {
                                  "default_description": Text(AppLocalizations.of(context)!.default_),
                                  "simple": Text(AppLocalizations.of(context)!.simple),
                                  "text_only": Text(AppLocalizations.of(context)!.textOnly),
                                }[dataColumnUsers.displayMode] ??
                                Text(AppLocalizations.of(context)!.sortedByDefault),
                        onTap: () => setStateBuilder(() => displeyModeModal(setStateBuilder)),
                        enabled: searchMode == "users",
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.openInBrowser),
                        onTap: () {
                          Navigator.pop(context);
                          openInBrowser(context, "https://vrchat.com/home/search/${searchBoxController.text}");
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
      drawer: drawer(context),
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
