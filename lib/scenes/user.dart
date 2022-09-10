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
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;
  final AppConfig appConfig;
  final VRChatAPI vrhatLoginSession;
  const VRChatMobileUser(this.appConfig, this.vrhatLoginSession, {Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );
  late List<Widget> popupMenu = [share(context, widget.appConfig, widget.vrhatLoginSession, "https://vrchat.com/home/user/${widget.userId}")];

  TextEditingController noteController = TextEditingController();

  @override
  initState() {
    super.initState();
    widget.vrhatLoginSession.users(widget.userId).then((VRChatUser user) {
      setState(
        () {
          noteController.text = user.note ?? "";
          column = Column(
            children: <Widget>[
              profile(context, widget.appConfig, widget.vrhatLoginSession, user),
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
                              onPressed: () => widget.vrhatLoginSession.userNotes(user.id, noteController.text).then((VRChatUserNotes response) {
                                    Navigator.pop(context);
                                    initState();
                                  }).catchError((status) {
                                    apiError(context, widget.appConfig, widget.vrhatLoginSession, status);
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
                    foregroundColor: Colors.grey,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileJsonViewer(widget.appConfig, widget.vrhatLoginSession, obj: user.content),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                ),
              ),
            ],
          );
        },
      );
      widget.vrhatLoginSession.friendStatus(widget.userId).then((VRChatfriendStatus status) {
        setState(
          () {
            popupMenu = <Widget>[
              profileAction(context, widget.appConfig, widget.vrhatLoginSession, status, widget.userId, initState),
              share(context, widget.appConfig, widget.vrhatLoginSession, "https://vrchat.com/home/user/${widget.userId}")
            ];
          },
        );
      }).catchError((status) {
        apiError(context, widget.appConfig, widget.vrhatLoginSession, status);
      });

      if (!["private", "offline", "traveling"].contains(user.location)) {
        widget.vrhatLoginSession.worlds(user.location.split(":")[0]).then((world) {
          setState(
            () {
              column = Column(children: column.children);
              column.children[1] = Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: simpleWorld(context, widget.appConfig, widget.vrhatLoginSession, world.toLimited()),
              );
            },
          );
          widget.vrhatLoginSession.instances(user.location).then((instance) {
            setState(
              () {
                column = Column(children: column.children);

                column.children[1] = Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: simpleWorldPlus(context, widget.appConfig, widget.vrhatLoginSession, world, instance),
                );
              },
            );
          }).catchError((status) {
            apiError(context, widget.appConfig, widget.vrhatLoginSession, status);
          });
        }).catchError((status) {
          apiError(context, widget.appConfig, widget.vrhatLoginSession, status);
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
      apiError(context, widget.appConfig, widget.vrhatLoginSession, status);
    });
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig, widget.vrhatLoginSession);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: popupMenu),
      drawer: Navigator.of(context).canPop() ? null : drawer(context, widget.appConfig, widget.vrhatLoginSession),
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
