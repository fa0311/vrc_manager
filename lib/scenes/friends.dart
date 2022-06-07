import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;

  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  int offset = 0;

  late Column column = Column(
    children: <Widget>[
      Text(AppLocalizations.of(context)!.loading),
    ],
  );

  Users dataColumn = Users();
  _FriendsPageState() {
    getStorage("FriendsJoinable").then((response) {
      moreOver();
      dataColumn.joinable = response == "true" && !widget.offline;
    });
  }
  moreOver() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).friends(offline: widget.offline, offset: offset).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        offset += 50;
        if (response.isEmpty) {
          setState(() => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ));
        } else {
          setState(() => column = Column(
                children: dataColumn.adds(response),
              ));
        }
        response.forEach((dynamic index, dynamic user) {
          String wid = user["location"].split(":")[0];
          if (["", "private", "offline"].contains(user["location"]) || dataColumn.locationMap.containsKey(wid)) return;
          VRChatAPI(cookie: cookie).worlds(wid).then((responseWorld) {
            if (responseWorld.containsKey("error")) {
              error(context, responseWorld["error"]["message"]);
              return;
            }
            dataColumn.locationMap[wid] = responseWorld;
            setState(() => column = Column(
                  children: dataColumn.reload(),
                ));
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dataColumn.context = context;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.frends), actions: <Widget>[
        if (!widget.offline)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                    builder: (BuildContext context, setStateBuilder) => SwitchListTile(
                          value: dataColumn.joinable,
                          title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
                          onChanged: (bool e) => setStateBuilder(() {
                            setStorage("FriendsJoinable", e ? "true" : "false");
                            dataColumn.joinable = e;
                            setState(() {
                              column = Column(
                                children: dataColumn.reload(),
                              );
                            });
                          }),
                        ))),
          )
      ]),
      drawer: drawr(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                column,
                if (dataColumn.length() == offset && offset > 0)
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
                  )
              ])))),
    );
  }
}
