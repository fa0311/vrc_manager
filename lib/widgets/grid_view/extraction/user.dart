// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/consumer.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/user.dart';

class ExtractionUser extends ConsumerGridWidget {
  final List<VRChatUser> userList;
  final VRChatFriendStatus? status;
  final ScrollPhysics? physics;

  const ExtractionUser({
    super.key,
    required super.id,
    required this.userList,
    this.status,
    this.physics,
  });

  @override
  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    List<VRChatUser> sortedUserList = sortUsers(config, userList);
    if (config.joinable) {
      sortedUserList.removeWhere((user) => ["private", "offline", "traveling"].contains(user.location));
    }

    return RenderGrid(
      width: 600,
      height: config.worldDetails ? 235 : 130,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: sortedUserList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatUser user = sortedUserList[index];
        return GenericTemplate(
          imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              )),
          onLongPress: () {
            showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => UserDetailsModalBottom(user: user, status: userStatus),
            );
          },
          children: [
            Username(user: user),
          ],
        );
      },
    );
  }

  @override
  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    List<VRChatUser> sortedUserList = sortUsers(config, userList);
    if (config.joinable) {
      sortedUserList.removeWhere((user) => ["private", "offline", "traveling"].contains(user.location));
    }

    return RenderGrid(
      width: 320,
      height: config.worldDetails ? 119 : 64,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: sortedUserList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatUser user = sortedUserList[index];
        return GenericTemplate(
          imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
          half: true,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              )),
          onLongPress: () {
            showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => UserDetailsModalBottom(user: user, status: userStatus),
            );
          },
          children: [
            Username(user: user, diameter: 12),
            for (String text in [
              if (user.statusDescription != null) user.statusDescription!,
            ].whereType<String>()) ...[
              Text(text, style: const TextStyle(fontSize: 10)),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    List<VRChatUser> sortedUserList = sortUsers(config, userList);
    if (config.joinable) {
      sortedUserList.removeWhere((user) => ["private", "offline", "traveling"].contains(user.location));
    }

    return RenderGrid(
      width: 400,
      height: config.worldDetails ? 39 : 26,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sortedUserList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatUser user = sortedUserList[index];
        return GenericTemplateText(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              )),
          onLongPress: () {
            showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => UserDetailsModalBottom(user: user, status: status!),
            );
          },
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Username(user: user, diameter: 15),
                if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
              ],
            ),
          ],
        );
      },
    );
  }
}
