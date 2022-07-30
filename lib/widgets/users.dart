// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class LocationDataClass {
  int id;
  int count = 0;
  LocationDataClass(this.id);
}

class Users {
  List<Widget> children = [];
  bool joinable = false;
  bool descending = false;
  bool worldDetails = true;
  String displayMode = "default";
  late BuildContext context;
  Map<String, VRChatWorld> locationMap = {};
  Map<String, VRChatInstance> instanceMap = {};
  List<VRChatUser> userList = [];

  List<Widget> reload() {
    children = [];
    List<VRChatUser> tempUserList = userList;
    userList = [];
    for (VRChatUser user in tempUserList) {
      add(user);
    }
    return children;
  }

  Map<String, LocationDataClass> numberOfFriendsInLocation() {
    Map<String, LocationDataClass> inLocation = {};
    int id = 0;
    for (VRChatUser user in userList) {
      String location = user.location;
      if (["private", "offline", "traveling"].contains(location) && joinable) continue;

      inLocation[location] ??= LocationDataClass(++id);
      inLocation[location]!.count++;
    }
    return inLocation;
  }

  List<Widget> sortByLocationMap() {
    Map<String, LocationDataClass> inLocation = numberOfFriendsInLocation();
    userList.sort((userA, userB) {
      String locationA = userA.location;
      String locationB = userB.location;
      if (locationA == locationB) return 0;
      if (["private", "offline", "traveling"].contains(locationA)) return 1;
      if (["private", "offline", "traveling"].contains(locationB)) return -1;
      if (inLocation[locationA]!.count > inLocation[locationB]!.count) return -1;
      if (inLocation[locationA]!.count < inLocation[locationB]!.count) return 1;
      if (inLocation[locationA]!.id > inLocation[locationB]!.id) return -1;
      if (inLocation[locationA]!.id < inLocation[locationB]!.id) return 1;
      return 0;
    });
    if (descending) userList = userList.reversed.toList();
    return reload();
  }

  List<Widget> sortByName() {
    userList.sort((userA, userB) {
      List<int> userBytesA = utf8.encode(userA.displayName);
      List<int> userBytesB = utf8.encode(userB.displayName);
      for (int i = 0; i < userBytesA.length && i < userBytesB.length; i++) {
        if (userBytesA[i] < userBytesB[i]) return -1;
        if (userBytesA[i] > userBytesB[i]) return 1;
      }
      if (userBytesA.length < userBytesB.length) return -1;
      if (userBytesA.length > userBytesB.length) return 1;
      return 0;
    });
    if (descending) userList = userList.reversed.toList();
    return reload();
  }

  List<Widget> sortByLastLogin() {
    userList.sort((userA, userB) {
      if (userA.lastLogin == null) return 1;
      if (userB.lastLogin == null) return -1;
      if (userA.lastLogin!.millisecondsSinceEpoch > userB.lastLogin!.millisecondsSinceEpoch) return -1;
      if (userA.lastLogin!.millisecondsSinceEpoch < userB.lastLogin!.millisecondsSinceEpoch) return 1;
      return 0;
    });
    if (descending) userList = userList.reversed.toList();
    return reload();
  }

  List<Widget> add(VRChatUser user) {
    userList.add(user);
    if (["private", "offline", "traveling"].contains(user.location) && joinable) return children;
    if (displayMode == "default") defaultAdd(user);
    if (displayMode == "simple") simpleAdd(user);
    if (displayMode == "text_only") textOnlyAdd(user);
    return children;
  }

  defaultAdd(VRChatUser user) {
    String worldId = user.location.split(":")[0];
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  ));
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                        fit: BoxFit.fitWidth,
                        progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                          width: 100,
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 100,
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              status(user.status, diameter: 20),
                              Container(
                                width: 5,
                              ),
                              Text(user.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 14)),
                          if (!["private", "offline", "traveling"].contains(user.location) && locationMap.containsKey(worldId))
                            Text(locationMap[worldId]!.name, style: const TextStyle(fontSize: 14)),
                          if (!["private", "offline", "traveling"].contains(user.location) && !locationMap.containsKey(worldId))
                            const SizedBox(
                              height: 15.0,
                              width: 15.0,
                              child: CircularProgressIndicator(),
                            ),
                          if (user.location == "private")
                            Text(
                              AppLocalizations.of(context)!.privateWorld,
                              style: const TextStyle(fontSize: 14),
                            ),
                          if (user.location == "traveling")
                            Text(
                              AppLocalizations.of(context)!.traveling,
                              style: const TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (worldDetails && locationMap[worldId] != null && instanceMap[user.location] == null)
                  simpleWorld(context, locationMap[worldId]!.toLimited()).child!,
                if (worldDetails && locationMap[worldId] != null && instanceMap[user.location] != null)
                  simpleWorldPlus(context, locationMap[worldId]!, instanceMap[user.location]!).child!
              ],
            ),
          ),
        ),
      ),
    );
  }

  simpleAdd(VRChatUser user) {
    String worldId = user.location.split(":")[0];
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  ));
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                        fit: BoxFit.fitWidth,
                        progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                          width: 50,
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 50,
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              status(user.status, diameter: 13),
                              Container(
                                width: 5,
                              ),
                              Text(
                                user.displayName,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          if (!["private", "offline", "traveling"].contains(user.location) && locationMap.containsKey(worldId))
                            Text(locationMap[worldId]!.name, style: const TextStyle(fontSize: 12)),
                          if (!["private", "offline", "traveling"].contains(user.location) && !locationMap.containsKey(worldId))
                            const SizedBox(
                              height: 15.0,
                              width: 15.0,
                              child: CircularProgressIndicator(),
                            ),
                          if (user.location == "private")
                            Text(
                              AppLocalizations.of(context)!.privateWorld,
                              style: const TextStyle(fontSize: 12),
                            ),
                          if (user.location == "traveling")
                            Text(
                              AppLocalizations.of(context)!.traveling,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (worldDetails && locationMap[worldId] != null && instanceMap[user.location] == null)
                  simpleWorldHalf(context, locationMap[worldId]!.toLimited()).child!,
                if (worldDetails && locationMap[worldId] != null && instanceMap[user.location] != null)
                  simpleWorldPlusHalf(context, locationMap[worldId]!, instanceMap[user.location]!).child!
              ],
            ),
          ),
        ),
      ),
    );
  }

  textOnlyAdd(VRChatUser user) {
    String worldId = user.location.split(":")[0];
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  ));
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        status(user.status, diameter: 12),
                        Container(
                          width: 5,
                        ),
                        Text(user.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                            )),
                        Container(
                          width: 15,
                        ),
                      ],
                    ),
                    if (!["private", "offline", "traveling"].contains(user.location) && locationMap.containsKey(worldId))
                      Text(locationMap[worldId]!.name, style: const TextStyle(fontSize: 12)),
                    if (!["private", "offline", "traveling"].contains(user.location) && !locationMap.containsKey(worldId))
                      const SizedBox(
                        height: 15.0,
                        width: 15.0,
                        child: CircularProgressIndicator(),
                      ),
                    if (user.location == "private")
                      Text(
                        AppLocalizations.of(context)!.privateWorld,
                        style: const TextStyle(fontSize: 12),
                      ),
                    if (user.location == "traveling")
                      Text(
                        AppLocalizations.of(context)!.traveling,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                if (worldDetails && locationMap[worldId] != null && instanceMap[user.location] != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${instanceMap[user.location]!.nUsers}/${instanceMap[user.location]!.capacity}", style: const TextStyle(fontSize: 12)),
                      if ((instanceMap[user.location]!.shortName ?? instanceMap[user.location]!.secureName) != null)
                        SizedBox(
                          height: 16,
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.grey,
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                            ),
                            onPressed: () => getLoginSession("login_session").then(
                              (cookie) => VRChatAPI(cookie: cookie ?? "")
                                  .selfInvite(instanceMap[user.location]!.location, instanceMap[user.location]!.shortName ?? "")
                                  .then((VRChatNotificationsInvite response) {
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
                            ),
                            child: Text(AppLocalizations.of(context)!.joinInstance, style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget render({required List<Widget> children}) {
    double width = MediaQuery.of(context).size.width;
    int height = 0;
    int wrap = 0;
    if (displayMode == "default") {
      height = worldDetails ? 240 : 130;
      wrap = 600;
    }
    if (displayMode == "simple") {
      height = worldDetails ? 150 : 70;
      wrap = 300;
    }
    if (displayMode == "text_only") {
      height = worldDetails ? 55 : 40;
      wrap = 400;
    }

    return GridView.count(
      crossAxisCount: width ~/ wrap + 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: width / (width ~/ wrap + 1) / height,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
