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
  bool worldDetails = false;
  String sortMode = "default";
  String displayMode = "default";
  String? cookie;

  Widget body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());

  Users dataColumn = Users();
  _FriendsPageState() {
    List<Future> futureStorageList = [];
    futureStorageList.add(getLoginSession("login_session").then(
      (response) {
        cookie = response;
      },
    ));
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
          updateSwitch();
        });
      },
    ));
    futureStorageList.add(getStorage("friends_world_details").then(
      (response) {
        setState(
          () {
            worldDetails = (response == "true");
            updateSwitch();
          },
        );
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

  updateSwitch() {
    if (widget.offline && sortMode == "friends_in_instance") sortMode = "default";
    delayedDisplay = (sortMode != "default");
    dataColumn.worldDetails = worldDetails;
    if (!dataColumn.joinable) dataColumn.worldDetails = false;
  }

  bool canMoreOver() {
    return (dataColumn.userList.length == offset);
  }

  sort() {
    if (dataColumn.wait) return;
    if (canMoreOver() && (autoReadMore || delayedDisplay)) return;
    if (!delayedDisplay) return;

    List<Widget> children = [];
    if (sortMode == "name") {
      children = dataColumn.sortByName();
    } else if (sortMode == "last_login") {
      children = dataColumn.sortByLastLogin();
    } else if (sortMode == "friends_in_instance") {
      children = dataColumn.sortByLocationMap();
    }
    setState(() => body = dataColumn.render(children: children));
  }

  laterMoreOver() {
    if (canMoreOver() && (autoReadMore || delayedDisplay)) {
      dataColumn.wait = true;
      setState(() => body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()));
      moreOver();
    }
  }

  Future<void> moreOver() {
    setState(() {
      offset += 50;
    });
    return VRChatAPI(cookie: cookie ?? "").friends(offline: widget.offline, offset: offset - 50).then((VRChatUserList users) {
      for (VRChatUser user in users.users) {
        dataColumn.add(user);
      }

      if (canMoreOver() && (autoReadMore || delayedDisplay)) {
        moreOver();
      } else {
        setState(
          () => body = dataColumn.render(
            children: dataColumn.reload(),
          ),
        );
      }

      getWorld(users);
      if (dataColumn.worldDetails) getInstance(users.users);
      sort();
    }).catchError((status) {
      apiError(context, status);
    });
  }

  getWorld(VRChatUserList users) {
    List<Future> futureList = [];
    for (VRChatUser user in users.users) {
      String wid = user.location.split(":")[0];
      if (["private", "offline", "traveling"].contains(user.location) || dataColumn.locationMap.containsKey(wid)) continue;
      futureList.add(
        VRChatAPI(cookie: cookie ?? "").worlds(wid).then((responseWorld) {
          dataColumn.locationMap[wid] = responseWorld;
        }).catchError((status) {
          apiError(context, status);
        }),
      );
      Future.wait(futureList).then(
        (value) {
          if (dataColumn.wait) return;
          setState(
            () => body = dataColumn.render(
              children: dataColumn.reload(),
            ),
          );
        },
      );
    }
  }

  getInstance(List<VRChatUser> users) {
    List<Future> futureList = [];
    for (VRChatUser user in users) {
      if (["private", "offline", "traveling"].contains(user.location) || dataColumn.instanceMap.containsKey(user.location)) continue;
      futureList.add(VRChatAPI(cookie: cookie ?? "").instances(user.location).then((VRChatInstance instance) {
        dataColumn.instanceMap[user.location] = instance;
      }).catchError((status) {
        apiError(context, status);
      }));
      Future.wait(futureList).then(
        (value) {
          if (dataColumn.wait) return;
          setState(() => body = dataColumn.render(
                children: dataColumn.reload(),
              ));
        },
      );
    }
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
                    updateSwitch();
                    laterMoreOver();
                    setStateBuilderParent(() => sort());
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sortedByName),
                trailing: sortMode == "name" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "name").then((value) {
                    updateSwitch();
                    laterMoreOver();
                    setStateBuilderParent(() => sort());
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sortedByLastLogin),
                trailing: sortMode == "last_login" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "last_login").then((value) {
                    updateSwitch();
                    laterMoreOver();
                    setStateBuilderParent(() => sort());
                  });
                }),
              ),
              if (!widget.offline)
                ListTile(
                  title: Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
                  trailing: sortMode == "friends_in_instance" ? const Icon(Icons.check) : null,
                  onTap: () => setStateBuilder(() {
                    setStorage("friends_sort", sortMode = "friends_in_instance").then((value) {
                      updateSwitch();
                      laterMoreOver();
                      setStateBuilderParent(() => sort());
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
                            updateSwitch();
                            laterMoreOver();
                            setStateBuilderParent(() => sort());
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
                title: Text(AppLocalizations.of(context)!.default_),
                trailing: dataColumn.displayMode == "default" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_display_mode", dataColumn.displayMode = "default").then((value) {
                    setState(() => body = dataColumn.render(
                          children: dataColumn.reload(),
                        ));
                    setStateBuilderParent(() {});
                  });
                }),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.simple),
                trailing: dataColumn.displayMode == "simple" ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  setStorage("friends_display_mode", dataColumn.displayMode = "simple").then((value) {
                    setState(() => body = dataColumn.render(
                          children: dataColumn.reload(),
                        ));
                    setStateBuilderParent(() {});
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
                      SwitchListTile(
                          value: autoReadMore || sortMode != "default",
                          title: Text(AppLocalizations.of(context)!.autoReadMore),
                          onChanged: sortMode == "default"
                              ? (bool e) => setStateBuilder(() {
                                    setStorage("auto_read_more", e ? "true" : "false");
                                    autoReadMore = e;
                                    updateSwitch();
                                    laterMoreOver();
                                    if (!canMoreOver()) {
                                      setState(
                                        () => body = dataColumn.render(children: dataColumn.reload()),
                                      );
                                    }
                                  })
                              : null),
                      if (!widget.offline)
                        SwitchListTile(
                          value: dataColumn.joinable,
                          title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
                          onChanged: (bool e) => setStateBuilder(
                            () {
                              setStorage("friends_joinable", e ? "true" : "false");
                              dataColumn.joinable = e;
                              updateSwitch();
                              laterMoreOver();
                              if (dataColumn.instanceMap.isEmpty) {
                                getInstance(dataColumn.userList);
                              }
                              if (!canMoreOver()) {
                                setState(
                                  () => body = dataColumn.render(children: dataColumn.reload()),
                                );
                              }
                            },
                          ),
                        ),
                      if (!widget.offline)
                        SwitchListTile(
                          value: dataColumn.worldDetails,
                          title: Text(AppLocalizations.of(context)!.worldDetails),
                          onChanged: dataColumn.joinable
                              ? (bool e) => setStateBuilder(
                                    () {
                                      setStorage("friends_world_details", e ? "true" : "false");
                                      worldDetails = e;
                                      updateSwitch();
                                      laterMoreOver();
                                      if (dataColumn.instanceMap.isEmpty) {
                                        getInstance(dataColumn.userList);
                                      }
                                      if (!canMoreOver()) {
                                        setState(
                                          () => body = dataColumn.render(children: dataColumn.reload()),
                                        );
                                      }
                                    },
                                  )
                              : null,
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
                          },
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
