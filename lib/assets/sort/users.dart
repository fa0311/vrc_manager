// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/storage/grid_modal.dart';

List<VRChatUser> sortUsers(GridConfigNotifier config, List<VRChatUser> userList) {
  switch (config.sortMode) {
    case SortMode.name:
      sortByNameFromUser(userList);
      break;
    case SortMode.lastLogin:
      sortByLastLoginFromUser(userList);
      break;
    case SortMode.friendsInInstance:
      sortByLocationMapFromUser(userList);
      break;
    default:
      break;
  }
  if (config.descending) {
    return userList.reversed.toList();
  } else {
    return userList;
  }
}

class LocationDataClass {
  int id;
  int count = 0;
  LocationDataClass(this.id);
}

Map<String, LocationDataClass> numberOfFriendsInLocation(List<VRChatUser> userList) {
  Map<String, LocationDataClass> inLocation = {};
  int id = 0;
  for (VRChatUser user in userList) {
    String location = user.location;
    inLocation[location] ??= LocationDataClass(++id);
    inLocation[location]!.count++;
  }
  return inLocation;
}

sortByLocationMapFromUser(List<VRChatUser> userList) {
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

sortByNameFromUser(List<VRChatUser> userList) {
  userList.sort((userA, userB) {
    List<int> userBytesA = utf8.encode(userA.displayName.toLowerCase());
    List<int> userBytesB = utf8.encode(userB.displayName.toLowerCase());
    for (int i = 0; i < userBytesA.length && i < userBytesB.length; i++) {
      if (userBytesA[i] < userBytesB[i]) return -1;
      if (userBytesA[i] > userBytesB[i]) return 1;
    }
    if (userBytesA.length < userBytesB.length) return -1;
    if (userBytesA.length > userBytesB.length) return 1;
    return 0;
  });
}

sortByLastLoginFromUser(List<VRChatUser> userList) {
  userList.sort((userA, userB) {
    if (userA.lastLogin == null) return 1;
    if (userB.lastLogin == null) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch > userB.lastLogin!.millisecondsSinceEpoch) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch < userB.lastLogin!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}
