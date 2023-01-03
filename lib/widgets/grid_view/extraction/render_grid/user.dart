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
    return RenderGrid(
      width: 600,
      height: config.worldDetails ? 235 : 130,
      children: [
        for (VRChatUser user in sortUsers(config, userList))
          () {
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  @override
  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    VRChatFriendStatus userStatus = status ?? VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
    return RenderGrid(
      width: 320,
      height: config.worldDetails ? 119 : 64,
      children: [
        for (VRChatUser user in sortUsers(config, userList))
          () {
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  @override
  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatUser user in sortUsers(config, userList))
          () {
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
          }(),
      ].whereType<Widget>().toList(),
    );
  }
}
