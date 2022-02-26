import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
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

  Column column = Column(
    children: const <Widget>[
      Text('ロード中です'),
    ],
  );

  Users dataColumn = Users();
  _FriendRequestPageState() {
    moreOver();
  }
  moreOver() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).notifications(type: "friendRequest", offset: offset).then((response) {
        offset += 100;
        if (response.isEmpty) {
          setState(() => column = Column(
                children: const <Widget>[
                  Text('なし'),
                ],
              ));
        }
        response.forEach((dynamic index, dynamic requestUser) {
          VRChatAPI(cookie: cookie).users(requestUser["senderUserId"]).then((user) {
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
        title: const Text('フレンドリクエスト'),
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
                          child: const Text('続きを読み込む'),
                          onPressed: () => moreOver(),
                        ),
                      ],
                    ),
                  )
              ])))),
    );
  }
}
