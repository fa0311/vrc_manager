// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

sortFavoriteWorlds(GridConfig config, List<VRChatLimitedWorld> worldlist) {
  if (config.sort == "name") {
    sortByNameFromWorlds(worldlist);
  } else if (config.sort == "updated_date") {
    sortByUpdatedDateFromWorlds(worldlist);
  } else if (config.sort == "labs_publication_date") {
    sortByLabsPublicationDateFromWorlds(worldlist);
  } else if (config.sort == "heat") {
    sortByHeatFavoriteFromWorlds(worldlist);
  } else if (config.sort == "capacity") {
    sortByCapacityFromWorlds(worldlist);
  } else if (config.sort == "occupants") {
    sortByOccupantsFromWorlds(worldlist);
  }
}

sortByNameFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
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

sortByUpdatedDateFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.updatedAt.millisecondsSinceEpoch > userB.updatedAt.millisecondsSinceEpoch) return -1;
    if (userA.updatedAt.millisecondsSinceEpoch < userB.updatedAt.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByLabsPublicationDateFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.labsPublicationDate == null) return 1;
    if (userB.labsPublicationDate == null) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch > userB.labsPublicationDate!.millisecondsSinceEpoch) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch < userB.labsPublicationDate!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByHeatFavoriteFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.heat > userB.heat) return -1;
    if (userA.heat < userB.heat) return 1;
    return 0;
  });
}

sortByCapacityFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.capacity > userB.capacity) return -1;
    if (userA.capacity < userB.capacity) return 1;
    return 0;
  });
}

sortByOccupantsFromWorlds(List<VRChatLimitedWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.occupants > userB.occupants) return -1;
    if (userA.occupants < userB.occupants) return 1;
    return 0;
  });
}
