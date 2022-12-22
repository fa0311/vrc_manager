// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
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
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);
  List<Future> futureList = [];
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  List<VRChatFriends> userList = [];
  int len;
  do {
    int offset = userList.length;
    List<VRChatFriends> users = await vrchatLoginSession.friends(offline: offline, offset: offset).catchError((e) {
      logger.e(getMessage(e), e);
    });
    userList.addAll(users);
    if (!offline) {
      for (VRChatFriends user in users) {
        futureList.add(getWorld(vrchatLoginSession: vrchatLoginSession, user: user, locationMap: locationMap).catchError((e) {
          logger.e(getMessage(e), e);
        }));
        futureList.add(getInstance(vrchatLoginSession: vrchatLoginSession, user: user, instanceMap: instanceMap).catchError((e) {
          logger.e(getMessage(e), e);
        }));
      }
    }
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
    AsyncValue<VRChatMobileFriendsData> data = ref.watch(vrchatMobileFriendsProvider(offline));

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileFriendsProvider(offline).future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: data.when(
            loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
            error: (e, trace) {
              logger.w(getMessage(e), e, trace);
              return const ErrorPage();
            },
            data: (data) => ExtractionFriend(
              id: offline ? GridModalConfigType.offlineFriends : GridModalConfigType.onlineFriends,
              userList: data.userList,
              locationMap: data.locationMap,
              instanceMap: data.instanceMap,
            ),
          ),
        ),
      ),
    );
  }
}
