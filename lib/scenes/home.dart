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

  TextEditingController bioController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  _LoginHomeState() {
    reload();
  }

  reload() {
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
            bioController.text = user.bio ?? "";
            noteController.text = user.note ?? "";
            setLoginSession("displayname", user.displayName);
            setState(
              () {
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
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: TextField(
                                controller: bioController,
                                maxLines: null,
                                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editBio),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(AppLocalizations.of(context)!.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                    child: Text(AppLocalizations.of(context)!.ok),
                                    onPressed: () => VRChatAPI(cookie: cookie).changeBio(user.id, bioController.text).then((VRChatUserPut response) {
                                          Navigator.pop(context);
                                          reload();
                                        }).catchError((status) {
                                          apiError(context, status);
                                        })),
                              ],
                            );
                          },
                        ),
                        child: Text(AppLocalizations.of(context)!.editBio),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
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
                                  onPressed: () => VRChatAPI(cookie: cookie).userNotes(user.id, noteController.text).then((VRChatUserNotes response) {
                                    Navigator.pop(context);
                                    reload();
                                  }).catchError((status) {
                                    apiError(context, status);
                                  }),
                                ),
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
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
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
                    ),
                  ],
                );
                popupMenu = [share(context, "https://vrchat.com/home/user/${response.id}")];
              },
            );
            if (!["private", "offline", "traveling"].contains(user.worldId)) {
              VRChatAPI(cookie: cookie).worlds(user.location.split(":")[0]).then((world) {
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
                VRChatAPI(cookie: cookie).instances(user.location).then((instance) {
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
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                      ),
                      privatesimpleWorld(context),
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
