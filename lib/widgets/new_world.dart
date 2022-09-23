import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

Future getWorld(BuildContext context, AppConfig appConfig, List<VRChatUser> users, Map<String, VRChatWorld?> locationMap) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatUser user in users) {
    String wid = user.location.split(":")[0];
    if (["private", "offline", "traveling"].contains(user.location) || locationMap.containsKey(wid)) continue;
    locationMap[wid] = null;
    futureList.add(vrhatLoginSession.worlds(wid).then((VRChatWorld world) {
      locationMap[wid] = world;
    }).catchError((status) {
      apiError(context, appConfig, status);
    }));
  }
  return Future.wait(futureList);
}

Future getWorldFromFavorite(BuildContext context, AppConfig appConfig, List<VRChatFavoriteGroup> favoriteGroups, Map<String, VRChatWorld?> locationMap) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatFavoriteGroup favoriteGroup in favoriteGroups) {
    String wid = favoriteGroup.id;
    if (["private", "offline", "traveling"].contains(wid) || locationMap.containsKey(wid)) continue;
    locationMap[wid] = null;
    futureList.add(vrhatLoginSession.worlds(wid).then((VRChatWorld world) {
      locationMap[wid] = world;
    }).catchError((status) {
      apiError(context, appConfig, status);
    }));
  }
  return Future.wait(futureList);
}

Future getInstance(BuildContext context, AppConfig appConfig, List<VRChatUser> users, Map<String, VRChatInstance?> instanceMap) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatUser user in users) {
    if (["private", "offline", "traveling"].contains(user.location) || instanceMap.containsKey(user.location)) continue;
    instanceMap[user.location] = null;
    futureList.add(vrhatLoginSession.instances(user.location).then((VRChatInstance instance) {
      instanceMap[user.location] = instance;
    }).catchError((status) {
      apiError(context, appConfig, status);
    }));
  }
  return Future.wait(futureList);
}

sortFavoriteWorlds(GridConfig config, List<VRChatFavoriteWorld> worldlist) {
  if (config.sort == "name") {
    sortByNameFromFavoriteWorlds(worldlist);
  }
}

sortByNameFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    List<int> userBytesA = utf8.encode(userA.name);
    List<int> userBytesB = utf8.encode(userB.name);
    for (int i = 0; i < userBytesA.length && i < userBytesB.length; i++) {
      if (userBytesA[i] < userBytesB[i]) return -1;
      if (userBytesA[i] > userBytesB[i]) return 1;
    }
    if (userBytesA.length < userBytesB.length) return -1;
    if (userBytesA.length > userBytesB.length) return 1;
    return 0;
  });
}
