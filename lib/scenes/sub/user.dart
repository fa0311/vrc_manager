// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/sub/json_viewer.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/profile.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;
  final AppConfig appConfig;

  const VRChatMobileUser(this.appConfig, {Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  VRChatUser? user;
  VRChatFriendStatus? status;
  VRChatWorld? world;
  VRChatInstance? instance;

  TextEditingController noteController = TextEditingController();

  @override
  initState() {
    super.initState();
    get();
  }

  Future get() async {
    await getUser().then((value) => setState(() {}));
    await getWorld().then((value) => setState(() {}));
  }

  Future getUser() async {
    user = await vrchatLoginSession.users(widget.userId).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
    if (user == null) return;
    noteController.text = user!.note ?? "";
    status = await vrchatLoginSession.friendStatus(widget.userId).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
  }

  Future getWorld() async {
    if (!["private", "offline", "traveling"].contains(user!.location)) {
      world = await vrchatLoginSession.worlds(user!.location.split(":")[0]).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      instance = await vrchatLoginSession.instances(user!.location).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: <Widget>[
        if (status != null) profileAction(context, widget.appConfig, status!, widget.userId, initState),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => modalBottom(context, shareUrlListTile(context, widget.appConfig, "https://vrchat.com/home/user/${widget.userId}")),
        )
      ]),
      drawer: Navigator.of(context).canPop() ? null : drawer(context, widget.appConfig),
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
              child: Column(
                children: <Widget>[
                  if (user == null)
                    const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())
                  else ...[
                    profile(context, widget.appConfig, user!),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => editNote(context, appConfig, setState, noteController, user!),
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
                            builder: (BuildContext context) => VRChatMobileJsonViewer(widget.appConfig, obj: user!.content),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (user!.location == "private") return privateWorld(context, appConfig);
                        if (user!.location == "traveling") return privateWorld(context, appConfig);
                        if (user!.location == "offline") return null;
                        if (world == null) return const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());
                        return instanceWidget(context, appConfig, world!, instance!);
                      }(),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
