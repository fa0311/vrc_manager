// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal/list_tile/user.dart';
import 'package:vrc_manager/widgets/user.dart';
import 'package:vrc_manager/widgets/share.dart';

List<Widget> selfUserModalBottom(
  BuildContext context,
  Function setState,
  VRChatUserSelfOverload user,
) {
  return [
    editBioTileWidget(context, setState, user),
    editNoteTileWidget(context, setState, user),
    shareUrlTileWidget(context, "https://vrchat.com/home/user/${user.id}"),
    if (appConfig.debugMode) openInJsonViewer(context, user.content),
  ];
}

List<Widget> userDetailsModalBottom(
  BuildContext context,
  Function setState,
  VRChatUser user,
  VRChatFriendStatus status,
) {
  return [
    editNoteTileWidget(context, setState, user),
    shareUrlTileWidget(context, "https://vrchat.com/home/user/${user.id}"),
    profileActionTileWidget(context, setState, status, user),
    if (appConfig.debugMode) openInJsonViewer(context, user.content),
    if (appConfig.debugMode) openInJsonViewer(context, status.content),
  ];
}

GridView extractionUserDefault(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList,
) {
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
            children: [
              username(user),
            ],
          );
        }(),
    ].whereType<Widget>().toList(),
  );
}

GridView extractionUserSimple(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList,
) {
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

GridView extractionUserText(
  BuildContext context,
  GridConfig config,
  List<VRChatUser> userList,
) {
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
