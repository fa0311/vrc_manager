// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
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
  List<Widget> popupMenu = [];

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  _LoginHomeState() {
    getLoginSession("login_session").then((cookie) {
      if (cookie == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobileLogin(),
          ),
          (_) => false,
        );
      } else {
        VRChatAPI(cookie: cookie).user().then((VRChatUserOverload response) {
          VRChatAPI(cookie: cookie).users(response.id).then((VRChatUser user) {
            setState(
              () {
                column = Column(
                  children: <Widget>[
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
                              builder: (BuildContext context) => VRChatMobileJsonViewer(obj: user.content),
                            ));
                      },
                      child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                    ),
                  ],
                );
                popupMenu = [share(context, "https://vrchat.com/home/user/${response.id}")];
              },
            );
            if (!["private", "offline"].contains(user.worldId)) {
              VRChatAPI(cookie: cookie).worlds(user.worldId.split(":")[0]).then((VRChatWorld world) {
                setState(
                  () {
                    column = Column(children: column.children);
                    column.children[1] = Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                        ),
                        simpleWorld(context, world.toLimited())
                      ],
                    );
                  },
                );
              }).catchError((status) {
                apiError(context, status);
              });
            }
            if (user.location == "private") {
              setState(
                () {
                  column = Column(children: column.children);
                  column.children[1] = Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                      ),
                      privatesimpleWorld(context)
                    ],
                  );
                },
              );
            }
          }).catchError((status) {
            apiError(context, status);
          });

          if (Platform.isAndroid || Platform.isIOS) {
            ReceiveSharingIntent.getTextStream().listen(
              (String value) {
                urlParser(context, value);
              },
            );
            ReceiveSharingIntent.getInitialText().then(
              (String? value) {
                if (value == null) return;
                urlParser(context, value);
              },
            );
          }
        }).catchError((status) {
          apiError(context, status);
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
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 30,
                left: 30,
              ),
              child: column,
            ),
          ),
        ),
      ),
    );
  }
}
