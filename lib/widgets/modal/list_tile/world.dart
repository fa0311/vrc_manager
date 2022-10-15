// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/world.dart';

List<Widget> worldDetailsModalBottom(
  BuildContext context,
  VRChatWorld world,
) {
  return [
    shareUrlTileWidget(context, "https://vrchat.com/home/world/${world.id}"),
    favoriteListTileWidget(context, world),
  ];
}

List<Widget> instanceDetailsModalBottom(
  BuildContext context,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    shareInstanceTileWidget(context, world.id, instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (appConfig.debugMode) openInJsonViewer(context, instance.content),
  ];
}

List<Widget> userInstanceDetailsModalBottom(
  BuildContext context,
  Function setState,
  VRChatUser user,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    shareUrlTileWidget(context, "https://vrchat.com/home/user/${user.id}"),
    shareInstanceTileWidget(context, world.id, instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (appConfig.debugMode) openInJsonViewer(context, instance.content),
  ];
}
