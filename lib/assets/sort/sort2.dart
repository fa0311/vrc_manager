import 'dart:convert';

import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

List<LimitedUser> sortUsers(GridConfigNotifier config, List<LimitedUser> userList) {
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

Map<String?, int> numberOfFriendsInLocation(List<LimitedUser> userList) {
  Map<String?, int> inLocation = {};
  for (final user in userList) {
    final location = user.location;
    inLocation[location] = (inLocation[location] ?? 0) + 1;
  }
  return inLocation;
}

sortByLocationMapFromUser(List<LimitedUser> userList) {
  final inLocation = numberOfFriendsInLocation(userList);
  userList.sort((userA, userB) {
    String? locationA = userA.location;
    String? locationB = userB.location;
    if (locationA == locationB) return 0;
    if (locationA == null) return 1;
    if (locationB == null) return -1;
    if (locationA == VRChatInstanceIdOther.offline.name) return 1;
    if (locationB == VRChatInstanceIdOther.offline.name) return -1;
    if (locationA == VRChatInstanceIdOther.private.name) return 1;
    if (locationB == VRChatInstanceIdOther.private.name) return -1;
    if (locationA == VRChatInstanceIdOther.traveling.name) return 1;
    if (locationB == VRChatInstanceIdOther.traveling.name) return -1;
    if (inLocation[locationA]! > inLocation[locationB]!) return -1;
    if (inLocation[locationA]! < inLocation[locationB]!) return 1;

    List<int> userBytesA = utf8.encode(locationA);
    List<int> userBytesB = utf8.encode(locationB);

    for (int i = 0; i < userBytesA.length && i < userBytesB.length; i++) {
      if (userBytesA[i] < userBytesB[i]) return -1;
      if (userBytesA[i] > userBytesB[i]) return 1;
    }
    if (userBytesA.length < userBytesB.length) return -1;
    if (userBytesA.length > userBytesB.length) return 1;
    return 0;
  });
}

sortByNameFromUser(List<LimitedUser> userList) {
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

sortByLastLoginFromUser(List<LimitedUser> userList) {
  userList.sort((userA, userB) {
    final castUserA = User.fromJson(userA.toJson());
    final castUserB = User.fromJson(userB.toJson());

    if (castUserA.lastLogin == null) return 1;
    if (castUserB.lastLogin == null) return -1;
    /*
    if (castUserA.lastLogin!.millisecondsSinceEpoch > castUserB.lastLogin!.millisecondsSinceEpoch) return -1;
    if (castUserA.lastLogin!.millisecondsSinceEpoch < castUserB.lastLogin!.millisecondsSinceEpoch) return 1;
    */
    return 0;
  });
}
