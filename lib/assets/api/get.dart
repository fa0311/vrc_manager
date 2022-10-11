// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/main.dart';

Future getWorld(BuildContext context, List<VRChatFriends> users, Map<String, VRChatWorld?> locationMap) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatFriends user in users) {
    String wid = user.location.split(":")[0];
    if (["private", "offline", "traveling"].contains(user.location) || locationMap.containsKey(wid)) continue;
    locationMap[wid] = null;
    futureList.add(vrchatLoginSession.worlds(wid).then((VRChatWorld world) {
      locationMap[wid] = world;
    }).catchError((status) {
      apiError(context, status);
    }));
  }
  return Future.wait(futureList);
}

Future getWorldFromFavorite(BuildContext context, List<VRChatFavoriteGroup> favoriteGroups, Map<String, VRChatWorld?> locationMap) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatFavoriteGroup favoriteGroup in favoriteGroups) {
    String wid = favoriteGroup.id;
    if (["private", "offline", "traveling"].contains(wid) || locationMap.containsKey(wid)) continue;
    locationMap[wid] = null;
    futureList.add(vrchatLoginSession.worlds(wid).then((VRChatWorld world) {
      locationMap[wid] = world;
    }).catchError((status) {
      apiError(context, status);
    }));
  }
  return Future.wait(futureList);
}

Future getInstance(BuildContext context, List<VRChatFriends> users, Map<String, VRChatInstance?> instanceMap) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  for (VRChatFriends user in users) {
    if (["private", "offline", "traveling"].contains(user.location) || instanceMap.containsKey(user.location)) continue;
    instanceMap[user.location] = null;
    futureList.add(vrchatLoginSession.instances(user.location).then((VRChatInstance instance) {
      instanceMap[user.location] = instance;
    }).catchError((status) {
      apiError(context, status);
    }));
  }
  return Future.wait(futureList);
}
