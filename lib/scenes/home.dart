import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';
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
    children: const <Widget>[
      SizedBox(width: double.infinity, child: Text('ロード中です')),
      Text('この画面がずっと表示されている場合、左のメニューから設定を開いてログアウトしてください'),
    ],
  );

  List<Widget> popupMenu = [];

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
          if (response.containsKey("error")) {
            error(context, response["error"]["message"]);
            return;
          }
          if (response.containsKey("id")) {
            VRChatAPI(cookie: cookie).users(response["id"]).then((user) {
              if (user.containsKey("error")) {
                error(context, user["error"]["message"]);
                return;
              }

              setState(() {
                column = Column(children: <Widget>[profile(user), Column()]);
                popupMenu = [
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          child: ListTile(
                              leading: const Icon(Icons.share),
                              title: const Text('共有'),
                              onTap: () {
                                Share.share("https://vrchat.com/home/user/${response['id']}");
                                Navigator.pop(context);
                              })),
                      PopupMenuItem(
                          child: ListTile(
                              leading: const Icon(Icons.copy),
                              title: const Text('コピー'),
                              onTap: () async {
                                final data = ClipboardData(text: "https://vrchat.com/home/user/${response['id']}");
                                await Clipboard.setData(data).then((value) => Navigator.pop(context));
                              })),
                    ],
                  )
                ];
              });
              if (!["", "private", "offline"].contains(user["worldId"])) {
                VRChatAPI(cookie: cookie).worlds(user["worldId"].split(":")[0]).then((world) {
                  if (world.containsKey("error")) {
                    error(context, world["error"]["message"]);
                    return;
                  }
                  setState(() {
                    column = Column(children: column.children);
                    column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), worldSlim(context, world)]);
                  });
                });
              }
              if (user["location"] == "private") {
                setState(() {
                  column = Column(children: column.children);
                  column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), privateWorldSlim()]);
                });
              }
            });
            if (Platform.isAndroid) {
              ReceiveSharingIntent.getTextStream().listen((String value) {
                urlParser(context, value);
              });
              ReceiveSharingIntent.getInitialText().then((String? value) {
                if (value == null) return;
                urlParser(context, value);
              });
            }
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
        actions: popupMenu,
      ),
      drawer: drawr(context),
      body: SafeArea(child: SingleChildScrollView(child: Container(padding: const EdgeInsets.only(top: 10, bottom: 50, right: 30, left: 30), child: column))),
    );
  }
}
