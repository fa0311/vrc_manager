import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  Column column = Column(
    children: const [
      SizedBox(width: double.infinity, child: Text('ロード中です')),
      Text('この画面がずっと表示されている場合、左のメニューから設定を開いてログアウトしてください'),
    ],
  );

  _LoginHomeState() {
    getLoginSession("LoginSession").then((cookie) {
      if (cookie == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const VRChatMobileLogin(),
            ),
            (_) => false);
      } else {
        VRChatAPI(cookie: cookie).user().then((response) {
          if (response.containsKey("id")) {
            VRChatAPI(cookie: cookie).users(response["id"]).then((user) {
              setState(() {
                column = Column(children: [profile(user)]);
              });
              if (!["", "offline"].contains(user["worldId"])) {
                VRChatAPI(cookie: cookie).worlds(user["worldId"]).then((response) {
                  setState(() {
                    column = Column(children: [profile(user), Container(padding: const EdgeInsets.only(top: 30)), worldSlim(context, response)]);
                  });
                });
              }
              if (user["location"] == "private") {
                setState(() {
                  column = Column(children: [profile(user), Container(padding: const EdgeInsets.only(top: 30)), privateWorldSlim(context)]);
                });
              }
            });
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const VRChatMobileLogin(),
                ),
                (_) => false);
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      drawer: drawr(context),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: SingleChildScrollView(child: column))),
    );
  }
}
