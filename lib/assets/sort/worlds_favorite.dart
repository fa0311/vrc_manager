import 'dart:convert';

import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

sortFavoriteWorlds(GridConfig config, List<VRChatFavoriteWorld> worldlist) {
  if (config.sort == "name") {
    sortByNameFromFavoriteWorlds(worldlist);
  } else if (config.sort == "updated_date") {
    sortByUpdatedDateFromFavoriteWorlds(worldlist);
  } else if (config.sort == "labs_publication_date") {
    sortByLabsPublicationDateFromFavoriteWorlds(worldlist);
  } else if (config.sort == "heat") {
    sortByHeatFavoriteFromFavoriteWorlds(worldlist);
  } else if (config.sort == "capacity") {
    sortByCapacityFromFavoriteWorlds(worldlist);
  } else if (config.sort == "occupants") {
    sortByOccupantsFromFavoriteWorlds(worldlist);
  }
}

sortByNameFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
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

sortByUpdatedDateFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.updatedAt.millisecondsSinceEpoch > userB.updatedAt.millisecondsSinceEpoch) return -1;
    if (userA.updatedAt.millisecondsSinceEpoch < userB.updatedAt.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByLabsPublicationDateFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.labsPublicationDate == null) return 1;
    if (userB.labsPublicationDate == null) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch > userB.labsPublicationDate!.millisecondsSinceEpoch) return -1;
    if (userA.labsPublicationDate!.millisecondsSinceEpoch < userB.labsPublicationDate!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}

sortByHeatFavoriteFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.heat > userB.heat) return -1;
    if (userA.heat < userB.heat) return 1;
    return 0;
  });
}

sortByCapacityFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.capacity > userB.capacity) return -1;
    if (userA.capacity < userB.capacity) return 1;
    return 0;
  });
}

sortByOccupantsFromFavoriteWorlds(List<VRChatFavoriteWorld> worldlist) {
  worldlist.sort((userA, userB) {
    if (userA.occupants > userB.occupants) return -1;
    if (userA.occupants < userB.occupants) return 1;
    return 0;
  });
}
