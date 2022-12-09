// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/friends.dart';

class VRChatMobileFriendsData {
  Map<String, VRChatWorld?> locationMap;
  Map<String, VRChatInstance?> instanceMap;
  List<VRChatFriends> userList;
  late GridConfigNotifier config;

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
    userList.addAll(users);
    if (!offline) {
      for (VRChatFriends user in users) {
        futureList.add(getWorld(user, locationMap).catchError((status) {
          if (kDebugMode) print(status);
        }));
        futureList.add(getInstance(user, instanceMap).catchError((status) {
          if (kDebugMode) print(status);
        }));
      }
    }
    len = users.length;
  } while (len == 50);
  await Future.wait(futureList);
  return VRChatMobileFriendsData(locationMap: locationMap, instanceMap: instanceMap, userList: userList);
});

final vrchatMobileFriendsSortProvider = FutureProvider.family<VRChatMobileFriendsData, bool>((ref, offline) async {
  VRChatMobileFriendsData data = await ref.watch(vrchatMobileFriendsProvider(offline).future);
  data.config = await ref.watch(gridConfigProvider.future);
  data.userList = sortUsers(data.config, data.userList);
  return data;
});

class VRChatMobileFriends extends ConsumerWidget {
  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileFriendsData> data = ref.watch(vrchatMobileFriendsSortProvider(offline));

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileFriendsProvider(offline).future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      switch (data.config.displayMode) {
                        case DisplayMode.normal:
                          return extractionFriendDefault(context, data.config, data.userList, data.locationMap, data.instanceMap);
                        case DisplayMode.simple:
                          return extractionFriendSimple(context, data.config, data.userList, data.locationMap, data.instanceMap);
                        case DisplayMode.textOnly:
                          return extractionFriendText(context, data.config, data.userList, data.locationMap, data.instanceMap);
                      }
                    }(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
