// Flutter imports:

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';

Future getWorld(VRChatFriends user, Map<String, VRChatWorld?> locationMap) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  String wid = user.location.split(":")[0];
  if (["private", "offline", "traveling"].contains(user.location) || locationMap.containsKey(wid)) return;
  locationMap[wid] = null;
  locationMap[wid] = await vrchatLoginSession.worlds(wid);
}

Future getWorldFromFavorite(VRChatFavoriteGroup favoriteGroup, Map<String, VRChatWorld?> locationMap) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  String wid = favoriteGroup.id;
  if (["private", "offline", "traveling"].contains(wid) || locationMap.containsKey(wid)) return;
  locationMap[wid] = null;
  locationMap[wid] = await vrchatLoginSession.worlds(wid);
}

Future getInstance(VRChatFriends user, Map<String, VRChatInstance?> instanceMap) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  if (["private", "offline", "traveling"].contains(user.location) || instanceMap.containsKey(user.location)) return;
  instanceMap[user.location] = null;
  instanceMap[user.location] = await vrchatLoginSession.instances(user.location);
}
