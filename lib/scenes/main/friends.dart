// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/render_grid/friends.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/scroll.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

class VRChatMobileFriendsData {
  Map<String, World?> locationMap;
  Map<String, Instance?> instanceMap;
  List<LimitedUser> userList;

  VRChatMobileFriendsData({
    required this.locationMap,
    required this.instanceMap,
    required this.userList,
  });
}

final vrchatMobileFriendsProvider = FutureProvider.family<VRChatMobileFriendsData, bool>((ref, offline) async {
  final session = await ref.read(getSessionProvider.future);

  List<Future> futureList = [];
  Map<String, World?> locationMap = {};
  Map<String, Instance?> instanceMap = {};
  List<LimitedUser> userList = [];
  int len;
  do {
    int offset = userList.length;
    final users = await session.rawApi.getFriendsApi().getFriends(offline: offline, offset: offset).catchError((e, trace) {
      logger.e(getMessage(e), e, trace);
    });
    userList.addAll(users.data!);

    if (!offline) {
      for (LimitedUser user in users.data!) {
        futureList.add(getWorld(session: session, user: user, locationMap: locationMap).catchError((e, trace) {
          logger.e(getMessage(e), e, trace);
        }));
        futureList.add(getInstance(session: session, user: user, instanceMap: instanceMap).catchError((e, trace) {
          logger.e(getMessage(e), e, trace);
        }));
      }
    }
    len = users.data!.length;
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
