// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/user.dart';

import 'package:vrc_manager/widgets/modal/list_tile/main.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;

  const VRChatMobileUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatUser? user;
  VRChatFriendStatus? status;
  VRChatWorld? world;
  VRChatInstance? instance;

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
      apiError(context, status);
    });
    if (user == null) return;
    status = await vrchatLoginSession.friendStatus(widget.userId).catchError((status) {
      apiError(context, status);
    });
  }

  Future getWorld() async {
    if (!["private", "offline", "traveling"].contains(user!.location)) {
      world = await vrchatLoginSession.worlds(user!.location.split(":")[0]).catchError((status) {
        apiError(context, status);
      });
      instance = await vrchatLoginSession.instances(user!.location).catchError((status) {
        apiError(context, status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: <Widget>[
        if (user != null && status != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => modalBottom(
              context,
              userDetailsModalBottom(context, user!, status!),
            ),
          ),
      ]),
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
              child: Column(
                children: <Widget>[
                  if (user == null)
                    const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())
                  else ...[
                    userProfile(context, user!),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (user!.location == "private") return privateWorld(context);
                        if (user!.location == "traveling") return privateWorld(context);
                        if (user!.location == "offline") return null;
                        if (world == null) return const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());
                        return instanceWidget(context, world!, instance!);
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
