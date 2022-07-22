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
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;
  const VRChatMobileUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );
  late List<Widget> popupMenu = [share(context, "https://vrchat.com/home/user/${widget.userId}")];

  _UserHomeState() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").users(widget.userId).then((VRChatUser user) {
          setState(
            () {
              column = Column(children: <Widget>[
                profile(context, user),
                Column(),
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
              ]);
            },
          );
          VRChatAPI(cookie: cookie ?? "").friendStatus(widget.userId).then((VRChatfriendStatus status) {
            setState(
              () {
                popupMenu = <Widget>[profileAction(context, status, widget.userId), share(context, "https://vrchat.com/home/user/${widget.userId}")];
              },
            );
          }).catchError((status) {
            apiError(context, status);
          });

          if (!["private", "offline"].contains(user.location)) {
            column.children[2] = TextButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.grey,
              ),
              onPressed: () => VRChatAPI(cookie: cookie ?? "").selfInvite(user.location).then((VRChatStatus response) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.sendInvite),
                      content: Text(AppLocalizations.of(context)!.selfInviteDetails),
                      actions: <Widget>[
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              }).catchError((status) {
                apiError(context, status);
              }),
              child: Text(AppLocalizations.of(context)!.joinInstance),
            );

            VRChatAPI(cookie: cookie ?? "").worlds(user.location.split(":")[0]).then((world) {
              setState(
                () {
                  column = Column(children: column.children);
                  column.children[1] = Column(
                    children: [
                      Container(padding: const EdgeInsets.only(top: 30)),
                      simpleWorld(context, world.toLimited()),
                    ],
                  );
                },
              );
              VRChatAPI(cookie: cookie ?? "").instances(user.location).then((instance) {
                setState(
                  () {
                    column = Column(children: column.children);
                    column.children[1] = Column(
                      children: [
                        Container(padding: const EdgeInsets.only(top: 30)),
                        simpleWorldPlus(context, world, instance),
                      ],
                    );
                  },
                );
              }).catchError((status) {
                apiError(context, status);
              });
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
                    Container(padding: const EdgeInsets.only(top: 30)),
                    privatesimpleWorld(context),
                  ],
                );
              },
            );
          }
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: popupMenu),
      drawer: Navigator.of(context).canPop() ? null : drawer(context),
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
                child: column),
          ),
        ),
      ),
    );
  }
}
