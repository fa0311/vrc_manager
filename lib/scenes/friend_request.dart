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
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';

class VRChatMobileFriendRequest extends StatefulWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriendRequest> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriendRequest> {
  int offset = 0;
  bool autoReadMore = false;
  bool delayedDisplay = false;
  String sortMode = "default";
  String displayMode = "default";
  String? cookie;

  Widget body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());

  Users dataColumn = Users();

  @override
  initState() {
    super.initState();
    List<Future> futureStorageList = [];
    futureStorageList.add(getLoginSession("login_session").then(
      (response) {
        cookie = response;
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
    if (!["default", "name"].contains(sortMode)) sortMode = "default";
    delayedDisplay = (sortMode != "default");
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
    return VRChatAPI(cookie: cookie ?? "").notifications(type: "friendRequest", offset: offset - 50).then((VRChatNotificationsList response) {
      List<Future> futureList = [];
      for (VRChatNotifications requestUser in response.notifications) {
        futureList.add(VRChatAPI(cookie: cookie ?? "").users(requestUser.senderUserId).then((VRChatUser user) {
          dataColumn.userList.add(user);
        }).catchError((status) {
          apiError(context, status);
        }));
      }
      Future.wait(futureList).then((value) {
        if (canMoreOver() && (autoReadMore || delayedDisplay)) {
          moreOver();
        } else {
          setState(
            () => body = dataColumn.render(
              children: dataColumn.reload(),
            ),
          );
        }
        sort();
      });
    }).catchError((status) {
      apiError(context, status);
    });
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
    textStream(context);
    dataColumn.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friendRequest),
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
