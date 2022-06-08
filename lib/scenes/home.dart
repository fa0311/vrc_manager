// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/url_parser.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  late Column column = Column(
    children: <Widget>[
      SizedBox(width: double.infinity, child: Text(AppLocalizations.of(context)!.loading)),
      Text(AppLocalizations.of(context)!.loadingDetails),
    ],
  );

  List<Widget> popupMenu = [];

  _LoginHomeState() {
    getLoginSession("LoginSession").then((cookie) {
      if (cookie == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const VRChatMobileLogin(),
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
                column = Column(children: <Widget>[
                  profile(context, user),
                  Column(),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => VRChatMobileJsonViewer(obj: user),
                          ));
                    },
                    child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                  ),
                ]);
                popupMenu = [share("https://vrchat.com/home/user/${response['id']}")];
              });
              if (!["", "private", "offline"].contains(user["worldId"])) {
                VRChatAPI(cookie: cookie).worlds(user["worldId"].split(":")[0]).then((world) {
                  if (world.containsKey("error")) {
                    error(context, world["error"]["message"]);
                    return;
                  }
                  setState(() {
                    column = Column(children: column.children);
                    column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), worldSimple(context, world)]);
                  });
                });
              }
              if (user["location"] == "private") {
                setState(() {
                  column = Column(children: column.children);
                  column.children[1] = Column(children: [Container(padding: const EdgeInsets.only(top: 30)), privateWorldSimple(context)]);
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
                  builder: (BuildContext context) => const VRChatMobileLogin(),
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
        title: Text(AppLocalizations.of(context)!.home),
        actions: popupMenu,
      ),
      drawer: drawr(context),
      body: SafeArea(child: SingleChildScrollView(child: Container(padding: const EdgeInsets.only(top: 10, bottom: 50, right: 30, left: 30), child: column))),
    );
  }
}
