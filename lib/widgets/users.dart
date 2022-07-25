// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

class LocationDataClass {
  int id;
  int count = 0;
  LocationDataClass(this.id);
}

class Users {
  List<Widget> children = [];
  bool joinable = false;
  bool descending = false;
  String displayMode = "default";
  late BuildContext context;
  Map<String, VRChatWorld> locationMap = {};
  List<VRChatUser> userList = [];

  List<Widget> reload() {
    children = [];
    List<VRChatUser> tempUserList = userList;
    userList = [];
    adds(tempUserList);
    return children;
  }

  Map<String, LocationDataClass> numberOfFriendsInLocation() {
    Map<String, LocationDataClass> inLocation = {};
    int id = 0;
    for (VRChatUser user in userList) {
      String location = user.location;
      if (["private", "offline"].contains(location) && joinable) continue;

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
      if (["private", "offline"].contains(locationA)) return 1;
      if (["private", "offline"].contains(locationB)) return -1;
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

  List<Widget> adds(List<VRChatUser> users) {
    for (VRChatUser user in users) {
      add(user);
    }
    return children;
  }

  List<Widget> add(VRChatUser user) {
    userList.add(user);
    if (["private", "offline"].contains(user.location) && joinable) return children;
    if (displayMode == "default") childrenAdd(user);
    if (displayMode == "simple") childrenAdd(user, imageSize: 50.0, nameFontSize: 16, statusView: false);
    return children;
  }

  childrenAdd(
    VRChatUser user, {
    double imageSize = 100.0,
    double nameFontSize = 20.0,
    bool statusView = false,
  }) {
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
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: imageSize,
                  child: CachedNetworkImage(
                    imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                    fit: BoxFit.fitWidth,
                    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                      width: imageSize,
                      child: const Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => SizedBox(
                      width: imageSize,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          status(user.status, diameter: nameFontSize),
                          Container(
                            width: 5,
                          ),
                          Text(user.displayName,
                              style: TextStyle(
                                fontWeight: nameFontSize > 19 ? FontWeight.bold : null,
                                fontSize: nameFontSize,
                              )),
                        ],
                      ),
                      if (user.statusDescription != null && statusView) Text(user.statusDescription!, style: const TextStyle(fontSize: 14)),
                      if (!["private", "offline"].contains(user.location) && locationMap.containsKey(user.location.split(":")[0]))
                        Text(locationMap[user.location.split(":")[0]]!.name, style: const TextStyle(fontSize: 14)),
                      if (!["private", "offline"].contains(user.location) && !locationMap.containsKey(user.location.split(":")[0]))
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
