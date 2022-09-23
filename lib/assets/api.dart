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
