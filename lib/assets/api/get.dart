// Flutter imports:

// Project imports:
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

Future getWorld({
  required VrchatDart session,
  required LimitedUser user,
  required Map<String, World?> locationMap,
}) async {
  if (user.location == null) return;
  final location = Location.fromString(user.location!);
  if (VRChatInstanceIdOther.values.any((id) => id.name == user.location) || locationMap.containsKey(location.worldId)) return;
  locationMap[location.worldId] = null;
  final response = await session.rawApi.getWorldsApi().getWorld(worldId: location.worldId).catchError((e, trace) {
    logger.e(getMessage(e), e, trace);
  });
  locationMap[location.worldId] = response.data;
}

Future getInstance({
  required VrchatDart session,
  required LimitedUser user,
  required Map<String, Instance?> instanceMap,
}) async {
  if (user.location == null) return;
  final location = Location.fromString(user.location!);
  if (VRChatInstanceIdOther.values.any((id) => id.name == user.location) || instanceMap.containsKey(user.location)) return;
  instanceMap[user.location!] = null;
  final response = await session.rawApi.getWorldsApi().getWorldInstance(worldId: location.worldId, instanceId: location.instanceId).catchError((e, trace) {
    logger.e(getMessage(e), e, trace);
  });
  instanceMap[user.location!] = response.data;
}

class Location {
  late String worldId;
  late String instanceId;

  Location({required this.worldId, required this.instanceId});

  Location.fromString(String location) {
    final split = (location).split(":");
    worldId = split[0];
    instanceId = split.length > 1 ? split[1] : "";
  }
}

enum VRChatInstanceType {
  public,
  hidden,
  friends,
  private;
}

enum VRChatInstanceIdOther {
  traveling,
  private,
  offline;
}
