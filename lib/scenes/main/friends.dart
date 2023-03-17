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
import 'package:vrc_manager/widgets/grid_view/extraction/render_grid/friends.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/scroll.dart';

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
  VRChatAPI vrchatLoginSession = VRChatAPI(
    cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
    userAgent: ref.watch(accountConfigProvider).userAgent,
    logger: logger,
  );
  List<Future> futureList = [];
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  List<VRChatFriends> userList = [];
  int len;
  do {
    int offset = userList.length;
    List<VRChatFriends> users = await vrchatLoginSession.friends(offline: offline, offset: offset).catchError((e, trace) {
      logger.e(getMessage(e), e, trace);
    });
    userList.addAll(users);
    if (!offline) {
      for (VRChatFriends user in users) {
        futureList.add(getWorld(vrchatLoginSession: vrchatLoginSession, user: user, locationMap: locationMap).catchError((e, trace) {
          logger.e(getMessage(e), e, trace);
        }));
        futureList.add(getInstance(vrchatLoginSession: vrchatLoginSession, user: user, instanceMap: instanceMap).catchError((e, trace) {
          logger.e(getMessage(e), e, trace);
        }));
      }
    }
    len = users.length;
  } while (len > 0);
  await Future.wait(futureList);
  return VRChatMobileFriendsData(locationMap: locationMap, instanceMap: instanceMap, userList: userList);
});

class VRChatMobileFriends extends ConsumerWidget {
  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileFriendsData> data = ref.watch(vrchatMobileFriendsProvider(offline));

    return data.when(
      loading: () => const Loading(),
      error: (e, trace) {
        logger.w(getMessage(e), e, trace);
        return ScrollWidget(
          onRefresh: () => ref.refresh(vrchatMobileFriendsProvider(offline).future),
          child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
        );
      },
      data: (data) => ScrollWidget(
        onRefresh: () => ref.refresh(vrchatMobileFriendsProvider(offline).future),
        child: ExtractionFriend(
          id: offline ? GridModalConfigType.offlineFriends : GridModalConfigType.onlineFriends,
          userList: data.userList,
          locationMap: data.locationMap,
          instanceMap: data.instanceMap,
        ),
      ),
    );
  }
}
