// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/assets/sort/worlds_favorite.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';

class SortData {
  SortMode sortedModeCache = SortMode.normal;
  bool sortedDescendCache = false;
  GridConfigNotifier config;
  SortData(this.config);

  List<VRChatUser> users(List<VRChatUser> userList) {
    if (config.sortMode != sortedModeCache) {
      sortUsers(config, userList);
      sortedModeCache = config.sortMode;
    }
    if (config.descending != sortedDescendCache) {
      userList = userList.reversed.toList();
      sortedDescendCache = config.descending;
    }
    return userList;
  }

  List<VRChatLimitedWorld> worlds(List<VRChatLimitedWorld> worldList) {
    if (config.sortMode != sortedModeCache) {
      sortWorlds(config, worldList);
      sortedModeCache = config.sortMode;
    }
    if (config.descending != sortedDescendCache) {
      worldList = worldList.reversed.toList();
      sortedDescendCache = config.descending;
    }
    return worldList;
  }
}
