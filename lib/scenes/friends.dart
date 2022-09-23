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
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/modal.dart';
import 'package:vrchat_mobile_client/widgets/new_users.dart';
import 'package:vrchat_mobile_client/widgets/new_world.dart';
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
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatUser> userList = [];
  String sortedModeCache = "default";
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    get().then((value) => setState(() {}));
  }

  GridView extractionDefault() {
    return renderGrid(
      context,
      width: 600,
      height: config.worldDetails ? 235 : 130,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return genericTemplate(
              context,
              appConfig,
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == "private") return privateWorld(context, appConfig, card: false);
                if (user.location == "traveling") return privateWorld(context, appConfig, card: false);
                if (user.location == "offline") null;
                if (locationMap[worldId] != null) {
                  return instanceWidget(context, appConfig, locationMap[worldId]!, instanceMap[user.location]!, card: false);
                } else {
                  return null;
                }
              }(),
              children: [
                username(user),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                  if (!["private", "offline", "traveling"].contains(user.location)) locationMap[worldId]!.name,
                  if (user.location == "private") AppLocalizations.of(context)!.privateWorld,
                  if (user.location == "traveling") AppLocalizations.of(context)!.traveling,
                ].whereType<String>()) ...[
                  Text(text, style: const TextStyle(fontSize: 15)),
                ],
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  GridView extractionSimple() {
    return renderGrid(
      context,
      width: 320,
      height: config.worldDetails ? 119 : 64,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return genericTemplate(
              context,
              appConfig,
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == "private") return privateWorld(context, appConfig, card: false, half: true);
                if (user.location == "traveling") return privateWorld(context, appConfig, card: false, half: true);
                if (user.location == "offline") null;
                if (locationMap[worldId] != null) {
                  return instanceWidget(context, appConfig, locationMap[worldId]!, instanceMap[user.location]!, card: false, half: true);
                } else {
                  return null;
                }
              }(),
              children: [
                username(user, diameter: 12),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                ].whereType<String>()) ...[
                  Text(text, style: const TextStyle(fontSize: 10)),
                ],
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  GridView extractionText() {
    return renderGrid(
      context,
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return genericTemplateText(
              context,
              appConfig,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    username(user, diameter: 15),
                    if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
                  ],
                ),
                if (config.worldDetails)
                  Text(() {
                    if (user.location == "private") return AppLocalizations.of(context)!.privateWorld;
                    if (user.location == "traveling") return AppLocalizations.of(context)!.traveling;
                    if (user.location == "offline") null;
                    if (locationMap[worldId] != null) return locationMap[worldId]!.name;
                    return "";
                  }(), style: const TextStyle(fontSize: 12, height: 1)),
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  Row username(VRChatUser user, {double diameter = 20}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        status(user.state == "offline" ? user.state! : user.status, diameter: diameter - 2),
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 5),
          child: Text(
            user.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: diameter,
            ),
          ),
        ),
      ],
    );
  }

  Future get() async {
    List<Future> futureList = [];
    int len;
    do {
      int offset = userList.length;
      VRChatUserList users = await vrhatLoginSession.friends(offline: widget.offline, offset: offset).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      if (!mounted) return;
      futureList.add(getWorld(context, appConfig, users.users, locationMap));
      futureList.add(getInstance(context, appConfig, users.users, instanceMap));
      for (VRChatUser user in users.users) {
        userList.add(user);
      }
      len = users.users.length;
    } while (len == 50);

    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    if (config.sort != sortedModeCache) {
      sort(config, userList);
      sortedModeCache = config.sort;
    }
    if (config.descending != sortedDescendCache) {
      userList = userList.reversed.toList();
      sortedDescendCache = config.descending;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friends),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, widget.appConfig, setState, config, gridConfig),
          ),
        ],
      ),
      drawer: drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              if (userList.isEmpty) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              if (userList.isNotEmpty && config.displayMode == "normal") extractionDefault(),
              if (userList.isNotEmpty && config.displayMode == "simple") extractionSimple(),
              if (userList.isNotEmpty && config.displayMode == "text_only") extractionText(),
            ]),
          ),
        ),
      ),
    );
  }
}
