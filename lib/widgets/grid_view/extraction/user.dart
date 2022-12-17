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

  const ExtractionUser({
    super.key,
    required super.id,
    required this.userList,
    required this.status,
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
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
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
                  builder: () {
                    return Column(children: userDetailsModalBottom(user, userStatus));
                  },
                );
              },
              children: [
                username(user),
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
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
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
                  builder: () {
                    return Column(children: userDetailsModalBottom(user, userStatus));
                  },
                );
              },
              children: [
                username(user, diameter: 12),
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
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            return GenericTemplateText(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () {
                    return Column(children: userDetailsModalBottom(user, status!));
                  },
                );
              },
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    username(user, diameter: 15),
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
