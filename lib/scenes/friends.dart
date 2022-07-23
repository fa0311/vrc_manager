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
  List<Future> futureList = [];

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
          delayedDisplay = (sortMode != "default");
          if (widget.offline && sortMode == "web_style") sortMode = "default";
        });
      },
    ));
    Future.wait(futureStorageList).then(((value) => moreOver()));
  }

  moreOver() {
    offset += 50;
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").friends(offline: widget.offline, offset: offset - 50).then((VRChatUserList users) {
          bool last = (users.users.length < 50);
          if (!last && (autoReadMore || delayedDisplay)) moreOver();

          if (last && delayedDisplay && sortMode == "web_style") {
            Future.wait(futureList).then(
              (value) => setState(() {
                column = Column(
                  children: dataColumn.sortByLocationMap(),
                );
              }),
            );
          } else if (last && delayedDisplay) {
            setState(() {
              if (sortMode == "name") {
                column = Column(
                  children: dataColumn.sortByName(),
                );
              } else if (sortMode == "last_login") {
                column = Column(
                  children: dataColumn.sortByLastLogin(),
                );
              }
            });
          } else if (!last && delayedDisplay) {
            for (VRChatUser user in users.users) {
              dataColumn.userList.add(user);
            }
          } else if (!last) {
            setState(() {
              column = Column(
                children: dataColumn.adds(users.users),
              );
            });
          }

          if (last && dataColumn.children.isEmpty && sortMode != "web_style") {
            setState(
              () => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ),
            );
          }

          for (VRChatUser user in users.users) {
            String wid = user.location.split(":")[0];
            if (["private", "offline"].contains(user.location) || dataColumn.locationMap.containsKey(wid)) continue;
            futureList.add(VRChatAPI(cookie: cookie ?? "").worlds(wid).then((responseWorld) {
              dataColumn.locationMap[wid] = responseWorld;
              if (delayedDisplay) return;
              setState(
                () => column = Column(
                  children: dataColumn.reload(),
                ),
              );
            }).catchError((status) {
              apiError(context, status);
            }));
          }
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
                title: const Text("Default"),
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "default").then(
                    (value) => setState(() {
                      delayedDisplay = false;
                      if (dataColumn.userList.length == offset && autoReadMore) {
                        moreOver();
                      }
                      setStateBuilderParent(() => Navigator.pop(context));
                    }),
                  );
                }),
              ),
              ListTile(
                title: const Text("Name"),
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "name").then(
                    (value) => setState(() {
                      delayedDisplay = true;
                      if (dataColumn.userList.length == offset) {
                        column = Column(
                          children: const [
                            Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                          ],
                        );
                        moreOver();
                      } else {
                        column = Column(
                          children: dataColumn.sortByName(),
                        );
                      }
                      setStateBuilderParent(() => Navigator.pop(context));
                    }),
                  );
                }),
              ),
              ListTile(
                title: const Text("Last login"),
                onTap: () => setStateBuilder(() {
                  setStorage("friends_sort", sortMode = "last_login").then(
                    (value) => setState(() {
                      delayedDisplay = true;
                      if (dataColumn.userList.length == offset) {
                        column = Column(
                          children: const [
                            Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                          ],
                        );
                        moreOver();
                      } else {
                        column = Column(
                          children: dataColumn.sortByLastLogin(),
                        );
                      }
                      setStateBuilderParent(() => Navigator.pop(context));
                    }),
                  );
                }),
              ),
              if (!widget.offline)
                ListTile(
                  title: const Text("Number of friends in the instance"),
                  onTap: () => setStateBuilder(() {
                    setStorage("friends_sort", sortMode = "web_style").then(
                      (value) => setState(() {
                        delayedDisplay = true;
                        if (dataColumn.userList.length == offset) {
                          column = Column(
                            children: const [
                              Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                            ],
                          );
                          moreOver();
                        } else {
                          column = Column(
                            children: dataColumn.sortByLocationMap(),
                          );
                        }
                        setStateBuilderParent(() => Navigator.pop(context));
                      }),
                    );
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
        title: Text(AppLocalizations.of(context)!.frends),
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
                                    moreOver();
                                    setStorage("auto_read_more", e ? "true" : "false");
                                    setState(() => autoReadMore = e);
                                  })
                              : null),
                      ListTile(
                        title: const Text("Sorted by"),
                        subtitle: {
                              "name": const Text("Name"),
                              "last_login": const Text("Last login"),
                              "web_style": const Text("Number of friends in the instance"),
                            }[sortMode] ??
                            const Text("Default"),
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
