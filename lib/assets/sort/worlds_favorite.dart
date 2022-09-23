import 'dart:convert';

import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

sortFavoriteWorlds(GridConfig config, List<VRChatFavoriteWorld> worldlist) {
  if (config.sort == "name") {
    sortByNameFromFavoriteWorlds(worldlist);
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
