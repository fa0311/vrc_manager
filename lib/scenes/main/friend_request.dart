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
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';

class VRChatMobileFriendRequestData {
  List<VRChatUser> userList;
  VRChatMobileFriendRequestData({required this.userList});
}

final vrchatMobileFriendsRequestProvider = FutureProvider<VRChatMobileFriendRequestData>((ref) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
  List<Future> futureList = [];
  List<VRChatUser> userList = [];
  int len;
  do {
    int offset = futureList.length;
    List<VRChatNotifications> notify = await vrchatLoginSession.notifications(type: "friendRequest", offset: offset).catchError((e) {
      logger.e(getMessage(e), e);
    });
    for (VRChatNotifications requestUser in notify) {
      futureList.add(vrchatLoginSession.users(requestUser.senderUserId).then((VRChatUser user) {
        userList.add(user);
      }).catchError((e) {
        logger.e(getMessage(e), e);
      }));
    }
    len = notify.length;
  } while (len == 50);
  await Future.wait(futureList);
  return VRChatMobileFriendRequestData(userList: userList);
});

class VRChatMobileFriendRequest extends ConsumerWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileFriendRequestData> data = ref.watch(vrchatMobileFriendsRequestProvider);
    VRChatFriendStatus status = VRChatFriendStatus(isFriend: false, incomingRequest: true, outgoingRequest: false);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileFriendsRequestProvider.future),
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
            data: (data) => ExtractionUser(id: GridModalConfigType.favoriteWorlds, userList: data.userList, status: status),
          ),
        ),
      ),
    );
  }
}
