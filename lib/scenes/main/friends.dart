// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/friends.dart';

class VRChatMobileFriendsData {
  Map<String, VRChatWorld?> locationMap;
  Map<String, VRChatInstance?> instanceMap;
  List<VRChatFriends> userList;

  VRChatMobileFriendsData({
    required this.locationMap,
    required this.instanceMap,
    required this.userList,
  });
}

final vrchatMobileFriendsProvider = FutureProvider.family<VRChatMobileFriendsData, bool>((ref, offline) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  List<VRChatFriends> userList = [];
  int len;
  do {
    int offset = userList.length;
    List<VRChatFriends> users = await vrchatLoginSession.friends(offline: offline, offset: offset);
    if (!offline) {
      futureList.add(getWorld(users, locationMap));
      futureList.add(getInstance(users, instanceMap));
    }
    userList.addAll(users);
    len = users.length;
  } while (len == 50);
  await Future.wait(futureList);
  return VRChatMobileFriendsData(locationMap: locationMap, instanceMap: instanceMap, userList: userList);
});

class VRChatMobileFriends extends ConsumerWidget {
  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileFriendsData> data = ref.watch(vrchatMobileFriendsProvider(offline));

    GridConfig config = offline ? appConfig.gridConfigList.offlineFriends : appConfig.gridConfigList.onlineFriends;
    SortData sortData = SortData(config);
    GridModalConfig gridConfig = GridModalConfig();

    gridConfig.url = "https://vrchat.com/home/locations";
    if (offline) {
      gridConfig.sortMode = [
        SortMode.normal,
        SortMode.name,
        SortMode.lastLogin,
      ];
      gridConfig.displayMode = [
        DisplayMode.normal,
        DisplayMode.simple,
        DisplayMode.textOnly,
      ];
    } else {
      gridConfig.joinable = true;
      gridConfig.worldDetails = true;
      gridConfig.sortMode = [
        SortMode.normal,
        SortMode.name,
        SortMode.friendsInInstance,
        SortMode.lastLogin,
      ];
      gridConfig.displayMode = [
        DisplayMode.normal,
        DisplayMode.simple,
        DisplayMode.textOnly,
      ];
    }

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Consumer(
          builder: (context, ref, child) {
            return data.when(
              loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err\n$stack'),
              data: (data) => Column(
                children: [
                  () {
                    data.userList = sortData.users(data.userList) as List<VRChatFriends>;
                    switch (config.displayMode) {
                      case DisplayMode.normal:
                        return extractionFriendDefault(context, config, data.userList, data.locationMap, data.instanceMap);
                      case DisplayMode.simple:
                        return extractionFriendSimple(context, config, data.userList, data.locationMap, data.instanceMap);
                      case DisplayMode.textOnly:
                        return extractionFriendText(context, config, data.userList, data.locationMap, data.instanceMap);
                    }
                  }(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
