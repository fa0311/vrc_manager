// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
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

  TextEditingController noteController = TextEditingController();

  @override
  initState() {
    super.initState();
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").users(widget.userId).then((VRChatUser user) {
          setState(
            () {
              noteController.text = user.note ?? "";
              column = Column(
                children: <Widget>[
                  profile(context, user),
                  Column(),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.grey,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: TextField(
                              controller: noteController,
                              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editNote),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context)!.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text(AppLocalizations.of(context)!.ok),
                                  onPressed: () => VRChatAPI(cookie: cookie ?? "").userNotes(user.id, noteController.text).then((VRChatUserNotes response) {
                                        Navigator.pop(context);
                                        initState();
                                      }).catchError((status) {
                                        apiError(context, status);
                                      })),
                            ],
                          );
                        },
                      ),
                      child: Text(AppLocalizations.of(context)!.editNote),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.grey,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VRChatMobileJsonViewer(obj: user.content),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                    ),
                  ),
                ],
              );
            },
          );
          VRChatAPI(cookie: cookie ?? "").friendStatus(widget.userId).then((VRChatfriendStatus status) {
            setState(
              () {
                popupMenu = <Widget>[profileAction(context, status, widget.userId, initState), share(context, "https://vrchat.com/home/user/${widget.userId}")];
              },
            );
          }).catchError((status) {
            apiError(context, status);
          });

          if (!["private", "offline", "traveling"].contains(user.location)) {
            VRChatAPI(cookie: cookie ?? "").worlds(user.location.split(":")[0]).then((world) {
              setState(
                () {
                  column = Column(children: column.children);
                  column.children[1] = Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: simpleWorld(context, world.toLimited()),
                  );
                },
              );
              VRChatAPI(cookie: cookie ?? "").instances(user.location).then((instance) {
                setState(
                  () {
                    column = Column(children: column.children);

                    column.children[1] = Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: simpleWorldPlus(context, world, instance),
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
                    privateSimpleWorld(context),
                  ],
                );
              },
            );
          }
          if (user.location == "traveling") {
            setState(
              () {
                column = Column(children: column.children);
                column.children[1] = Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                    ),
                    travelingWorld(context),
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
    textStream(context);
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
