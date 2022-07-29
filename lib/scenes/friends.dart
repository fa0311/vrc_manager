// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;

  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  int offset = 0;
  bool autoReadMore = false;
  bool delayedDisplay = false;
  String sortMode = "default";
  String displayMode = "default";

  Widget body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());

  Users dataColumn = Users();
  _FriendsPageState() {
    List<Future> futureStorageList = [];
    futureStorageList.add(getStorage("friends_joinable").then(
      (response) {
        dataColumn.joinable = response == "true" && !widget.offline;
      },
    ));
    futureStorageList.add(getStorage("auto_read_more").then(
      (response) {
        setState(
          () => autoReadMore = (response == "true"),
        );
      },
    ));
    futureStorageList.add(getStorage("friends_sort").then(
      (response) {
        setState(() {
          sortMode = response ?? "default";
          updateSortMode();
        });
      },
    ));
    futureStorageList.add(getStorage("friends_display_mode").then(
      (response) {
        setState(
          () => dataColumn.displayMode = response ?? "default",
        );
      },
    ));
    futureStorageList.add(getStorage("friends_descending").then(
      (response) {
        setState(
          () => dataColumn.descending = (response == "true"),
        );
      },
    ));
    Future.wait(futureStorageList).then(((value) => moreOver()));
  }

  updateSortMode() {
    if (widget.offline && sortMode == "friends_in_instance") sortMode = "default";
    delayedDisplay = (sortMode != "default");
  }

  bool canMoreOver() {
    return (dataColumn.userList.length == offset);
  }

  sort() {
    if (canMoreOver() && (autoReadMore || delayedDisplay)) {
      if (dataColumn.children.isNotEmpty) {
        setState(() => body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()));
      }
      moreOver();
    } else if (delayedDisplay) {
      List<Widget> children = [];
      if (sortMode == "name") {
        children = dataColumn.sortByName();
      } else if (sortMode == "last_login") {
        children = dataColumn.sortByLastLogin();
      } else if (sortMode == "friends_in_instance") {
        children = dataColumn.sortByLocationMap();
      }
      if (children.isEmpty) {
        setState(() => body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()));
      } else {
        setState(() => body = dataColumn.render(children: children));
      }
    }
  }

  Future<void> moreOver() {
    offset += 50;
    return getLoginSession("login_session").then(
      (cookie) {
        return VRChatAPI(cookie: cookie ?? "").friends(offline: widget.offline, offset: offset - 50).then((VRChatUserList users) {
          if (delayedDisplay) {
            for (VRChatUser user in users.users) {
              dataColumn.userList.add(user);
            }
          } else {
            for (VRChatUser user in users.users) {
              dataColumn.add(user);
            }
            setState(() {
              body = dataColumn.render(children: dataColumn.children);
            });
          }

          if (!canMoreOver() && dataColumn.children.isEmpty && !delayedDisplay) {
            setState(() => body = Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]));
          }

          for (VRChatUser user in users.users) {
            String wid = user.location.split(":")[0];
            if (["private", "offline", "traveling"].contains(user.location) || dataColumn.locationMap.containsKey(wid)) continue;
            VRChatAPI(cookie: cookie ?? "").worlds(wid).then((responseWorld) {
              dataColumn.locationMap[wid] = responseWorld;
              if (dataColumn.children.isEmpty) return;
              setState(() => body = dataColumn.render(
                    children: dataColumn.reload(),
                  ));
            }).catchError((status) {
              apiError(context, status);
            });
          }
          sort();
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  sortModal(Function setStateBuilderParent) {
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
                title: Text(AppLocalizations.of(context)!.sortedByDefault),
                trailing: sortMode == "default" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "default").then((value) {
                    updateSortMode();
                    sort();
                    setStateBuilderParent(() => Navigator.pop(context));
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sortedByName),
                trailing: sortMode == "name" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "name").then((value) {
                    updateSortMode();
                    sort();
                    setStateBuilderParent(() => Navigator.pop(context));
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sortedByLastLogin),
                trailing: sortMode == "last_login" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "last_login").then((value) {
                    updateSortMode();
                    sort();
                    setStateBuilderParent(() => Navigator.pop(context));
                  });
                }),
              ),
              if (!widget.offline)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
                  trailing: sortMode == "friends_in_instance" ? const Icon(Icons.check) : null,
                  onTap: () => setStateBuilder(() {
                    setStorage("friends_sort", sortMode = "friends_in_instance").then((value) {
                      updateSortMode();
                      sort();
                      setStateBuilderParent(() => Navigator.pop(context));
                    });
                  }),
                ),
              if (!widget.offline)
                SwitchListTile(
                  value: dataColumn.descending && sortMode != "default",
                  title: Text(AppLocalizations.of(context)!.descending),
                  onChanged: sortMode == "default"
                      ? null
                      : (bool e) => setStateBuilder(() {
                            dataColumn.descending = e;
                            setStorage("friends_descending", e ? "true" : "false");
                            updateSortMode();
                            sort();
                          }),
                ),
            ],
          ),
        ),
      ),
    );
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
                title: Text(AppLocalizations.of(context)!.display),
                trailing: dataColumn.displayMode == "default" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_display_mode", dataColumn.displayMode = "default").then((value) {
                    setState(() => body = dataColumn.render(
                          children: dataColumn.reload(),
                        ));
                    setStateBuilderParent(() => Navigator.pop(context));
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumn.displayMode == "simple" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_display_mode", dataColumn.displayMode = "simple").then((value) {
                    setState(() => body = dataColumn.render(
                          children: dataColumn.reload(),
                        ));
                    setStateBuilderParent(() => Navigator.pop(context));
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.textOnly),
                trailing: dataColumn.displayMode == "text_only" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_display_mode", dataColumn.displayMode = "text_only").then((value) {
                    setState(() => body = dataColumn.render(
                          children: dataColumn.reload(),
                        ));
                    setStateBuilderParent(() => Navigator.pop(context));
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
    dataColumn.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friends),
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
                      if (!widget.offline)
                        SwitchListTile(
                          value: dataColumn.joinable,
                          title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
                          onChanged: (bool e) => setStateBuilder(
                            () {
                              setStorage("friends_joinable", e ? "true" : "false");
                              dataColumn.joinable = e;
                              setState(
                                () => body = dataColumn.render(
                                  children: dataColumn.reload(),
                                ),
                              );
                            },
                          ),
                        ),
                      SwitchListTile(
                          value: autoReadMore || sortMode != "default",
                          title: Text(AppLocalizations.of(context)!.autoReadMore),
                          onChanged: sortMode == "default"
                              ? (bool e) => setStateBuilder(() {
                                    setState(() => autoReadMore = e);
                                    if (canMoreOver() && autoReadMore) moreOver();
                                    setStorage("auto_read_more", e ? "true" : "false");
                                  })
                              : null),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.sort),
                        subtitle: {
                              "name": Text(AppLocalizations.of(context)!.sortedByName),
                              "last_login": Text(AppLocalizations.of(context)!.sortedByLastLogin),
                              "friends_in_instance": Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
                            }[sortMode] ??
                            Text(AppLocalizations.of(context)!.sortedByDefault),
                        onTap: () => setStateBuilder(() => sortModal(setStateBuilder)),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.display),
                        subtitle: {
                              "default": Text(AppLocalizations.of(context)!.default_),
                              "simple": Text(AppLocalizations.of(context)!.simple),
                              "text_only": Text(AppLocalizations.of(context)!.textOnly),
                            }[dataColumn.displayMode] ??
                            Text(AppLocalizations.of(context)!.sortedByDefault),
                        onTap: () => setStateBuilder(() => displeyModeModal(setStateBuilder)),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.openInBrowser),
                        onTap: () {
                          Navigator.pop(context);
                          openInBrowser(context, "https://vrchat.com/home/locations");
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
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                body,
                if (dataColumn.userList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                            child: Text(AppLocalizations.of(context)!.readMore),
                            onPressed: () {
                              moreOver().then((_) => setState(() => body = dataColumn.render(children: dataColumn.reload())));
                            }),
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
