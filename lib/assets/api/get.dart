// Flutter imports:

// Project imports:
import 'package:vrc_manager/api/assets/instance_type.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';

Future getWorld({
  required VRChatAPI vrchatLoginSession,
  required VRChatFriends user,
  required Map<String, VRChatWorld?> locationMap,
}) async {
  try {
    String wid = user.location.split(":")[0];
    if (VRChatInstanceIdOther.values.any((id) => id.name == user.location) || locationMap.containsKey(wid)) return;
    locationMap[wid] = null;
    locationMap[wid] = await vrchatLoginSession.worlds(wid);
  } catch (e, trace) {
    logger.e(getMessage(e), error: e, stackTrace: trace);
  }
}

Future getWorldFromFavorite({
  required VRChatAPI vrchatLoginSession,
  required VRChatFavoriteGroup favoriteGroup,
  required Map<String, VRChatWorld?> locationMap,
}) async {
  try {
    String wid = favoriteGroup.id;
    if (VRChatInstanceIdOther.values.any((id) => id.name == wid) || locationMap.containsKey(wid)) return;
    locationMap[wid] = null;
    locationMap[wid] = await vrchatLoginSession.worlds(wid);
  } catch (e, trace) {
    logger.e(getMessage(e), error: e, stackTrace: trace);
  }
}

Future getInstance({
  required VRChatAPI vrchatLoginSession,
  required VRChatFriends user,
  required Map<String, VRChatInstance?> instanceMap,
}) async {
  try {
    if (VRChatInstanceIdOther.values.any((id) => id.name == user.location) || instanceMap.containsKey(user.location)) return;
    instanceMap[user.location] = null;
    instanceMap[user.location] = await vrchatLoginSession.instances(user.location);
  } catch (e, trace) {
    logger.e(getMessage(e), error: e, stackTrace: trace);
  }
}
