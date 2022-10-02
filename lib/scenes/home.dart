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
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/legacy_world.dart';

class VRChatMobileHome extends StatefulWidget {
  final AppConfig appConfig;
  const VRChatMobileHome(this.appConfig, {Key? key}) : super(key: key);
  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  List<Widget> popupMenu = [];

  TextEditingController bioController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  @override
  initState() {
    super.initState();
    vrhatLoginSession.user().then((VRChatUserSelfOverload response) {
      vrhatLoginSession.users(response.id).then((VRChatFriends user) {
        bioController.text = user.bio ?? "";
        noteController.text = user.note ?? "";
        widget.appConfig.loggedAccount?.setDisplayName(user.displayName);

        setState(
          () {
            column = Column(
              children: <Widget>[
                profile(context, widget.appConfig, user),
                Column(),
                SizedBox(
                  height: 30,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                                onPressed: () => vrhatLoginSession.changeBio(user.id, bioController.text).then((VRChatUserSelf response) {
                                      Navigator.pop(context);
                                      initState();
                                    }).catchError((status) {
                                      apiError(context, widget.appConfig, status);
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
                      foregroundColor: Colors.grey,
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
                              onPressed: () => vrhatLoginSession.userNotes(user.id, noteController.text).then((VRChatUserNotes response) {
                                Navigator.pop(context);
                                initState();
                              }).catchError((status) {
                                apiError(context, widget.appConfig, status);
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
                      foregroundColor: Colors.grey,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileJsonViewer(widget.appConfig, obj: user.content),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                  ),
                ),
              ],
            );
            popupMenu = [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => modalBottom(context, shareUrlListTile(context, widget.appConfig, "https://vrchat.com/home/user/${response.id}")),
              )
            ];
          },
        );
        if (!["private", "offline", "traveling"].contains(user.worldId)) {
          vrhatLoginSession.worlds(user.location.split(":")[0]).then((world) {
            setState(
              () {
                column = Column(children: column.children);
                column.children[1] = Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: simpleWorld(context, widget.appConfig, world.toLimited()),
                );
              },
            );
            vrhatLoginSession.instances(user.location).then((instance) {
              setState(
                () {
                  column = Column(children: column.children);
                  column.children[1] = Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: simpleWorldPlus(context, widget.appConfig, world, instance),
                  );
                },
              );
            }).catchError((status) {
              apiError(context, widget.appConfig, status);
            });
          }).catchError((status) {
            apiError(context, widget.appConfig, status);
          });
        }
        if (user.location == "private") {
          setState(
            () {
              column = Column(children: column.children);
              column.children[1] = Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: privateSimpleWorld(context),
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
        apiError(context, widget.appConfig, status);
      });
    }).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: popupMenu,
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: AppBar(
          title: Text(AppLocalizations.of(context)!.home),
          actions: popupMenu,
        ),
      ),
      drawer: drawer(context, widget.appConfig),
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
