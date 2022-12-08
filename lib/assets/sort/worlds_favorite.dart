// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';

sortWorlds(GridConfigNotifier config, List<VRChatLimitedWorld> worldList) {
  switch (config.sortMode) {
    case SortMode.name:
      sortByNameFromWorlds(worldList);
      break;
    case SortMode.updatedDate:
      sortByUpdatedDateFromWorlds(worldList);
      break;
    case SortMode.labsPublicationDate:
      sortByLabsPublicationDateFromWorlds(worldList);
      break;
    case SortMode.heat:
      sortByHeatFavoriteFromWorlds(worldList);
      break;
    case SortMode.capacity:
      sortByCapacityFromWorlds(worldList);
      break;
    case SortMode.occupants:
      sortByOccupantsFromWorlds(worldList);
      break;
    default:
      break;
  }
}

sortByNameFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
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

sortByUpdatedDateFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
    if (userA.updatedAt.millisecondsSinceEpoch > userB.updatedAt.millisecondsSinceEpoch) return -1;
    if (userA.updatedAt.millisecondsSinceEpoch < userB.updatedAt.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByLabsPublicationDateFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
    if (userA.labsPublicationDate == null) return 1;
    if (userB.labsPublicationDate == null) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch > userB.labsPublicationDate!.millisecondsSinceEpoch) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch < userB.labsPublicationDate!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByHeatFavoriteFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
    if (userA.heat > userB.heat) return -1;
    if (userA.heat < userB.heat) return 1;
    return 0;
  });
}

sortByCapacityFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
    if (userA.capacity > userB.capacity) return -1;
    if (userA.capacity < userB.capacity) return 1;
    return 0;
  });
}

sortByOccupantsFromWorlds(List<VRChatLimitedWorld> worldList) {
  worldList.sort((userA, userB) {
    if (userA.occupants > userB.occupants) return -1;
    if (userA.occupants < userB.occupants) return 1;
    return 0;
  });
}
