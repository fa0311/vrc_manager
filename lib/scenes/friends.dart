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

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  Users dataColumn = Users();
  _FriendsPageState() {
    getStorage("friends_joinable").then(
      (response) {
        moreOver();
        dataColumn.joinable = response == "true" && !widget.offline;
      },
    );
    getStorage("auto_read_more").then(
      (response) {
        setState(
          () => autoReadMore = (response == "true"),
        );
      },
    );
  }
  moreOver() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").friends(offline: widget.offline, offset: offset).then((VRChatUserList users) {
          offset += 50;
          if (users.users.isEmpty && dataColumn.children.isEmpty) {
            setState(
              () => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ),
            );
          } else {
            setState(() {
              column = Column(
                children: dataColumn.adds(users.users),
              );
            });
          }
          for (VRChatUser user in users.users) {
            String wid = user.location.split(":")[0];
            if (["private", "offline"].contains(user.location) || dataColumn.locationMap.containsKey(wid)) continue;
            VRChatAPI(cookie: cookie ?? "").worlds(wid).then((responseWorld) {
              dataColumn.locationMap[wid] = responseWorld;
              dataColumn.sortByLocationMap();
              setState(
                () => column = Column(
                  children: dataColumn.reload(),
                ),
              );
            }).catchError((status) {
              apiError(context, status);
            });
          }
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dataColumn.context = context;
    getStorage("auto_read_more").then((response) {
      if (dataColumn.children.length == offset && offset > 0 && response == "true") moreOver();
    });
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
                        value: autoReadMore,
                        title: Text(AppLocalizations.of(context)!.autoReadMore),
                        onChanged: (bool e) => setStateBuilder(() {
                          setStorage("auto_read_more", e ? "true" : "false");
                          setState(() => autoReadMore = e);
                        }),
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
                if (dataColumn.children.length == offset && offset > 0)
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
