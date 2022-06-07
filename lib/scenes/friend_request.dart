// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';

class VRChatMobileFriendRequest extends StatefulWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriendRequest> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<VRChatMobileFriendRequest> {
  int offset = 0;
  List<Widget> children = [];

  late Column column = Column(
    children: <Widget>[
      Text(AppLocalizations.of(context)!.loading),
    ],
  );

  Users dataColumn = Users();
  _FriendRequestPageState() {
    moreOver();
  }
  moreOver() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).notifications(type: "friendRequest", offset: offset).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        offset += 100;
        if (response.isEmpty) {
          setState(() => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ));
        }
        response.forEach((dynamic index, dynamic requestUser) {
          VRChatAPI(cookie: cookie).users(requestUser["senderUserId"]).then((user) {
            if (user.containsKey("error")) {
              error(context, user["error"]["message"]);
              return;
            }
            setState(() => column = Column(
                  children: dataColumn.adds({0: user}),
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friendRequest),
      ),
      drawer: drawr(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
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
                  )
              ])))),
    );
  }
}
