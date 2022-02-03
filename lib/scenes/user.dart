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
    children: const [
      Text('ロード中です'),
    ],
  );

  _UserHomeState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).users(widget.userId).then((user) {
        setState(() {
          column = Column(children: [profile(user)]);
        });
        if (!["", "private"].contains(user["location"])) {
          VRChatAPI(cookie: cookie).worlds(user["location"].split(":")[0]).then((response) {
            setState(() {
              column = Column(children: [profile(user), Container(padding: const EdgeInsets.only(top: 30)), worldSlim(context, response)]);
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フレンド'),
      ),
      drawer: drawr(context),
      body: SafeArea(child: SingleChildScrollView(child: Container(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30), child: column))),
    );
  }
}
