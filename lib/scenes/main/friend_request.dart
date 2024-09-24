// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/render_grid/user.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/scroll.dart';

class VRChatMobileFriendRequestData {
  List<VRChatUser> userList;
  VRChatMobileFriendRequestData({required this.userList});
}

final vrchatMobileFriendsRequestProvider = FutureProvider<VRChatMobileFriendRequestData>((ref) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(
    cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
    userAgent: ref.watch(accountConfigProvider).userAgent,
    logger: logger,
  );
  List<Future> futureList = [];
  List<VRChatUser> userList = [];
  int len;
  try {
    do {
      int offset = futureList.length;
      List<VRChatNotifications> notify = await vrchatLoginSession.notifications(type: "friendRequest", offset: offset);
      for (VRChatNotifications requestUser in notify) {
        futureList.add(vrchatLoginSession.users(requestUser.senderUserId).then((VRChatUser user) {
          userList.add(user);
        }).catchError((e, trace) {
          logger.e(getMessage(e), error: e, stackTrace: trace);
        }));
      }
      len = notify.length;
    } while (len > 0);
  } catch (e, trace) {
    logger.e(getMessage(e), error: e, stackTrace: trace);
  }
  await Future.wait(futureList);
  return VRChatMobileFriendRequestData(userList: userList);
});

class VRChatMobileFriendRequest extends ConsumerWidget {
  const VRChatMobileFriendRequest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileFriendRequestData> data = ref.watch(vrchatMobileFriendsRequestProvider);
    VRChatFriendStatus status = VRChatFriendStatus(isFriend: false, incomingRequest: true, outgoingRequest: false);

    return data.when(
      loading: () => const Loading(),
      error: (e, trace) {
        logger.w(getMessage(e), error: e, stackTrace: trace);
        return ScrollWidget(
          onRefresh: () => ref.refresh(vrchatMobileFriendsRequestProvider.future),
          child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
        );
      },
      data: (data) => ScrollWidget(
        onRefresh: () => ref.refresh(vrchatMobileFriendsRequestProvider.future),
        child: ExtractionUser(id: GridModalConfigType.favoriteWorlds, userList: data.userList, status: status),
      ),
    );
  }
}
