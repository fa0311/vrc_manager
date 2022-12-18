// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';

class VRChatMobileFriendRequestData {
  List<VRChatUser> userList;
  VRChatMobileFriendRequestData({required this.userList});
}

final vrchatMobileFriendsProvider = FutureProvider<VRChatMobileFriendRequestData>((ref) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider)!.cookie);
  List<Future> futureList = [];
  List<VRChatUser> userList = [];
  int len;
  do {
    int offset = futureList.length;
    List<VRChatNotifications> notify = await vrchatLoginSession.notifications(type: "friendRequest", offset: offset);
    for (VRChatNotifications requestUser in notify) {
      futureList.add(vrchatLoginSession.users(requestUser.senderUserId).then((VRChatUser user) {
        userList.add(user);
      }).catchError((status) {
        if (kDebugMode) print(status);
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
    AsyncValue<VRChatMobileFriendRequestData> data = ref.watch(vrchatMobileFriendsProvider);
    VRChatFriendStatus status = VRChatFriendStatus(isFriend: false, incomingRequest: true, outgoingRequest: false);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileFriendsProvider.future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: data.when(
            loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (data) => ExtractionUser(id: GridModalConfigType.favoriteWorlds, userList: data.userList, status: status),
          ),
        ),
      ),
    );
  }
}
