// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/user.dart';
import 'package:vrc_manager/widgets/user.dart';

Widget extractionUserDefault(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList, {
  VRChatFriendStatus? status,
}) {
  return Consumer(
    builder: (context, ref, _) {
      status ??= VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
      return renderGrid(
        context,
        width: 600,
        height: config.worldDetails ? 235 : 130,
        children: [
          for (VRChatUser user in userList)
            () {
              if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
              return genericTemplate(
                context,
                imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                    )),
                onLongPress: () => modalBottom(context, userDetailsModalBottom(context, ref, user, status!)),
                children: [
                  username(user),
                ],
              );
            }(),
        ].whereType<Widget>().toList(),
      );
    },
  );
}

Widget extractionUserSimple(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList, {
  VRChatFriendStatus? status,
}) {
  return Consumer(
    builder: (context, ref, _) {
      status ??= VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
      return renderGrid(
        context,
        width: 320,
        height: config.worldDetails ? 119 : 64,
        children: [
          for (VRChatUser user in userList)
            () {
              if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
              return genericTemplate(
                context,
                imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                half: true,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                    )),
                onLongPress: () => modalBottom(context, userDetailsModalBottom(context, ref, user, status!)),
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
    },
  );
}

Widget extractionUserText(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList, {
  VRChatFriendStatus? status,
}) {
  return Consumer(
    builder: (context, ref, _) {
      status ??= VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);
      return renderGrid(
        context,
        width: 400,
        height: config.worldDetails ? 39 : 26,
        children: [
          for (VRChatUser user in userList)
            () {
              if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
              return genericTemplateText(
                context,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                    )),
                onLongPress: () => modalBottom(context, userDetailsModalBottom(context, ref, user, status!)),
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
    },
  );
}
