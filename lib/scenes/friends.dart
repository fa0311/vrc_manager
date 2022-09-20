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
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/modal.dart';
import 'package:vrchat_mobile_client/widgets/new_users.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;
  final AppConfig appConfig;

  const VRChatMobileFriends(this.appConfig, {Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.offline ? widget.appConfig.gridConfigList.offlineFriends : widget.appConfig.gridConfigList.onlineFriends;
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  List<VRChatUser> userList = [];

  Widget body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());

  @override
  initState() {
    super.initState();
    get().then((value) => setState(() {
          body = renderGrid(context, width: 600, height: 233, children: [
            for (VRChatUser user in userList) extraction(user),
          ]);
        }));
  }

  Card extraction(VRChatUser user) {
    String worldId = user.location.split(":")[0];
    return defaultAdd(
      context,
      appConfig,
      user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
      [
        username(user),
        ...toTextWidget([
          if (user.statusDescription != null) user.statusDescription!,
          if (!["private", "offline", "traveling"].contains(user.location) && locationMap.containsKey(worldId)) locationMap[worldId]!.name,
          if (!["private", "offline", "traveling"].contains(user.location) && !locationMap.containsKey(worldId)) "エラー",
          if (user.location == "private") AppLocalizations.of(context)!.privateWorld,
          if (user.location == "traveling") AppLocalizations.of(context)!.traveling,
        ])
      ],
    );
  }

  Row username(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        status(user.state == "offline" ? user.state! : user.status, diameter: 20),
        Container(
          width: 5,
        ),
        Text(
          user.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Future get() async {
    int offset = 0;
    List<Future> futureList = [];
    do {
      VRChatUserList users = await vrhatLoginSession.friends(offline: widget.offline, offset: offset).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      futureList.add(getWorld(users));
      futureList.add(getInstance(users));
      for (VRChatUser user in users.users) {
        userList.add(user);
      }
      offset += 50;
    } while (userList.length % 50 == 0);

    return Future.wait(futureList);
  }

  Future getWorld(VRChatUserList users) {
    List<Future> futureList = [];
    for (VRChatUser user in users.users) {
      String wid = user.location.split(":")[0];
      if (["private", "offline", "traveling"].contains(user.location) || locationMap.containsKey(wid)) continue;
      locationMap[wid] = null;
      futureList.add(vrhatLoginSession.worlds(wid).then((VRChatWorld world) {
        locationMap[wid] = world;
      }).catchError((status) {
        apiError(context, widget.appConfig, status);
      }));
    }
    return Future.wait(futureList);
  }

  Future getInstance(VRChatUserList users) {
    List<Future> futureList = [];
    for (VRChatUser user in users.users) {
      if (["private", "offline", "traveling"].contains(user.location) || instanceMap.containsKey(user.location)) continue;
      instanceMap[user.location] = null;
      futureList.add(vrhatLoginSession.instances(user.location).then((VRChatInstance instance) {
        instanceMap[user.location] = instance;
      }).catchError((status) {
        apiError(context, widget.appConfig, status);
      }));
    }
    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friends),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, widget.appConfig, config),
          ),
        ],
      ),
      drawer: drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: body,
          ),
        ),
      ),
    );
  }
}
