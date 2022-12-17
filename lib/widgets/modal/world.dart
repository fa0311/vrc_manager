// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/world.dart';

List<Widget> worldDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatWorld world,
) {
  return [
    ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/world/${world.id}")),
    favoriteListTileWidget(context, world),
    launchWorldListTileWidget(context, world),
    if (ref.read(accessibilityConfigProvider).debugMode) OpenInJsonViewer(content: world.content),
  ];
}

List<Widget> instanceDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (ref.read(accessibilityConfigProvider).debugMode) OpenInJsonViewer(content: instance.content),
  ];
}

List<Widget> userInstanceDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatUser user,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/user/${user.id}")),
    ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (ref.read(accessibilityConfigProvider).debugMode) OpenInJsonViewer(content: instance.content),
  ];
}

Widget selfInviteListTileWidget(BuildContext context, VRChatInstance instance) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.joinInstance),
    onTap: () {
      selfInvite(context, instance);
    },
  );
}

Widget favoriteListTileWidget(BuildContext context, VRChatLimitedWorld world) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.addFavoriteWorlds),
    onTap: () => showModalBottomSheetStatelessWidget(context: context, builder: () => FavoriteAction(world: world)),
  );
}

Widget launchWorldListTileWidget(BuildContext context, VRChatLimitedWorld world) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.launchWorld),
    onTap: () {
      launchWorld(context, world);
    },
  );
}
