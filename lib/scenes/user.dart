import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;

  const VRChatMobileUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  Column column = Column(
    children: const <Widget>[
      Text('ロード中です'),
    ],
  );
  Widget? dial;

  _UserHomeState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).users(widget.userId).then((user) {
        setState(() {
          column = Column(children: <Widget>[profile(user), Column()]);
        });
        VRChatAPI(cookie: cookie).friendStatus(widget.userId).then((status) {
          setState(() {
            dial = profileAction(context, status, widget.userId);
          });
        });
        if (!["", "private", "offline"].contains(user["location"])) {
          VRChatAPI(cookie: cookie).worlds(user["location"].split(":")[0]).then((world) {
            setState(() {
              column = Column(children: column.children);
              column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), worldSlim(context, world)]);
            });
            VRChatAPI(cookie: cookie).instances(user["location"]).then((instance) {
              setState(() {
                column = Column(children: column.children);
                column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), worldSlimPlus(context, world, instance)]);
              });
            });
          });
        }
        if (user["location"] == "private") {
          setState(() {
            column = Column(children: [profile(user), Container(padding: const EdgeInsets.only(top: 30)), privateWorldSlim()]);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ユーザー'), actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(child: ListTile(leading: Icon(Icons.share), title: Text('共有'))),
          ],
        )
      ]),
      drawer: drawr(context),
      body: SafeArea(child: SingleChildScrollView(child: Container(padding: const EdgeInsets.only(top: 10, bottom: 50, right: 30, left: 30), child: column))),
      floatingActionButton: dial,
    );
  }
}
