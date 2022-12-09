// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';

class VRChatMobileFriendRequestData {
  List<VRChatUser> userList;
  late GridConfigNotifier config;
  VRChatMobileFriendRequestData({required this.userList});
}

final vrchatMobileFriendsProvider = FutureProvider<VRChatMobileFriendRequestData>((ref) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
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

final vrchatMobileFriendsSortProvider = FutureProvider<VRChatMobileFriendRequestData>((ref) async {
  VRChatMobileFriendRequestData data = await ref.watch(vrchatMobileFriendsProvider.future);
  data.config = await ref.watch(gridConfigProvider.future);
  data.userList = sortUsers(data.config, data.userList);
  return data;
});

class VRChatMobileFriendRequest extends ConsumerWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileFriendRequestData> data = ref.watch(vrchatMobileFriendsSortProvider);

    VRChatFriendStatus status = VRChatFriendStatus(isFriend: false, incomingRequest: true, outgoingRequest: false);

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Consumer(
          builder: (context, ref, child) {
            return data.when(
              loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (data) => Column(
                children: [
                  () {
                    switch (data.config.displayMode) {
                      case DisplayMode.normal:
                        return extractionUserDefault(context, data.config, data.userList, status: status);
                      case DisplayMode.simple:
                        return extractionUserSimple(context, data.config, data.userList, status: status);
                      case DisplayMode.textOnly:
                        return extractionUserText(context, data.config, data.userList, status: status);
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
