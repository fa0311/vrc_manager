// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

sortUser(GridConfig config, List<VRChatFriends> userList) {
  if (config.sort == "name") {
    sortByNameFromUser(userList);
  } else if (config.sort == "last_login") {
    sortByLastLoginFromUser(userList);
  } else if (config.sort == "friends_in_instance") {
    sortByLocationMapFromUser(userList);
  }
}

class LocationDataClass {
  int id;
  int count = 0;
  LocationDataClass(this.id);
}

Map<String, LocationDataClass> numberOfFriendsInLocation(List<VRChatFriends> userList) {
  Map<String, LocationDataClass> inLocation = {};
  int id = 0;
  for (VRChatFriends user in userList) {
    String location = user.location;
    inLocation[location] ??= LocationDataClass(++id);
    inLocation[location]!.count++;
  }
  return inLocation;
}

sortByLocationMapFromUser(List<VRChatFriends> userList) {
  Map<String, LocationDataClass> inLocation = numberOfFriendsInLocation(userList);
  userList.sort((userA, userB) {
    String locationA = userA.location;
    String locationB = userB.location;
    if (locationA == locationB) return 0;
    if (locationA == "offline") return 1;
    if (locationB == "offline") return -1;
    if (locationA == "private") return 1;
    if (locationB == "private") return -1;
    if (locationA == "traveling") return 1;
    if (locationB == "traveling") return -1;
    if (inLocation[locationA]!.count > inLocation[locationB]!.count) return -1;
    if (inLocation[locationA]!.count < inLocation[locationB]!.count) return 1;
    if (inLocation[locationA]!.id > inLocation[locationB]!.id) return -1;
    if (inLocation[locationA]!.id < inLocation[locationB]!.id) return 1;
    return 0;
  });
}

sortByNameFromUser(List<VRChatFriends> userList) {
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
}

sortByLastLoginFromUser(List<VRChatFriends> userList) {
  userList.sort((userA, userB) {
    if (userA.lastLogin == null) return 1;
    if (userB.lastLogin == null) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch > userB.lastLogin!.millisecondsSinceEpoch) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch < userB.lastLogin!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}
