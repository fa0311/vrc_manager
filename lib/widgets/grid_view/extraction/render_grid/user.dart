// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/assets/instance_type.dart';
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

  const ExtractionUser({
    super.key,
    required super.id,
    required this.userList,
    this.status,
  });

  @override
  List<Widget> normal(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    return [
      for (VRChatUser user in sortUsers(config, userList))
        () {
          if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
          return GenericTemplate(
            imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl ?? "",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              ),
            ),
            onLongPress: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => UserDetailsModalBottom(user: user, status: userStatus),
              );
            },
            children: [
              Username(user: user, diameter: style.title.fontSize, fontWeight: style.title.fontWeight),
            ],
          );
        }(),
    ].whereType<Widget>().toList();
  }

  @override
  List<Widget> simple(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    return [
      for (VRChatUser user in sortUsers(config, userList))
        () {
          if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
          return GenericTemplate(
            imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl ?? "",
            half: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              ),
            ),
            onLongPress: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => UserDetailsModalBottom(user: user, status: userStatus),
              );
            },
            children: [
              Username(user: user, diameter: style.title.fontSize, fontWeight: style.title.fontWeight),
            ],
          );
        }(),
    ].whereType<Widget>().toList();
  }

  @override
  List<Widget> textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    return [
      for (VRChatUser user in sortUsers(config, userList))
        () {
          if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
          return GenericTemplateText(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
              ),
            ),
            onLongPress: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => UserDetailsModalBottom(user: user, status: userStatus),
              );
            },
            children: [
              Username(user: user, diameter: style.title.fontSize, fontWeight: style.title.fontWeight),
            ],
          );
        }(),
    ].whereType<Widget>().toList();
  }
}
