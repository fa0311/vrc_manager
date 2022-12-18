// Flutter imports:

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';

Future getWorld({
  required VRChatAPI vrchatLoginSession,
  required VRChatFriends user,
  required Map<String, VRChatWorld?> locationMap,
}) async {
  String wid = user.location.split(":")[0];
  if (["private", "offline", "traveling"].contains(user.location) || locationMap.containsKey(wid)) return;
  locationMap[wid] = null;
  locationMap[wid] = await vrchatLoginSession.worlds(wid);
}

Future getWorldFromFavorite({
  required VRChatAPI vrchatLoginSession,
  required VRChatFavoriteGroup favoriteGroup,
  required Map<String, VRChatWorld?> locationMap,
}) async {
  String wid = favoriteGroup.id;
  if (["private", "offline", "traveling"].contains(wid) || locationMap.containsKey(wid)) return;
  locationMap[wid] = null;
  locationMap[wid] = await vrchatLoginSession.worlds(wid);
}

Future getInstance({
  required VRChatAPI vrchatLoginSession,
  required VRChatFriends user,
  required Map<String, VRChatInstance?> instanceMap,
}) async {
  if (["private", "offline", "traveling"].contains(user.location) || instanceMap.containsKey(user.location)) return;
  instanceMap[user.location] = null;
  instanceMap[user.location] = await vrchatLoginSession.instances(user.location);
}
