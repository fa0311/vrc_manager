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

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

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
        List<Widget> children = [];
        children = [const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())];
        setState(() => column = Column(children: children));
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
        children = [Text(AppLocalizations.of(context)!.none)];
      }
      setState(() => column = Column(children: children));
    }
  }

  moreOver() {
    offset += 50;
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").friends(offline: widget.offline, offset: offset - 50).then((VRChatUserList users) {
          if (delayedDisplay) {
            for (VRChatUser user in users.users) {
              dataColumn.userList.add(user);
            }
          } else {
            setState(() {
              column = Column(children: dataColumn.adds(users.users));
            });
          }

          if (!canMoreOver() && dataColumn.children.isEmpty && !delayedDisplay) {
            setState(() => column = Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]));
          }

          for (VRChatUser user in users.users) {
            String wid = user.location.split(":")[0];
            if (["private", "offline"].contains(user.location) || dataColumn.locationMap.containsKey(wid)) continue;
            VRChatAPI(cookie: cookie ?? "").worlds(wid).then((responseWorld) {
              dataColumn.locationMap[wid] = responseWorld;
              if (dataColumn.children.isEmpty) return;
              setState(() => column = Column(
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

  sortModal(setStateBuilderParent) {
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
                  onTap: () => setStateBuilder(() {
                    setStorage("friends_sort", sortMode = "friends_in_instance").then((value) {
                      updateSortMode();
                      sort();
                      setStateBuilderParent(() => Navigator.pop(context));
                    });
                  }),
                )
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
                builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
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
                                () => column = Column(
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
                column,
                if (dataColumn.userList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(),
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
