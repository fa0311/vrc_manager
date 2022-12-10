// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/world.dart';

List<Widget> worldDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatWorld world,
) {
  return [
    shareUrlTileWidget(context, Uri.https("vrchat.com", "/home/world/${world.id}")),
    favoriteListTileWidget(context, world),
    launchWorldListTileWidget(context, world),
    if (ref.read(accessibilityConfigProvider).debugMode) openInJsonViewer(context, world.content),
  ];
}

List<Widget> instanceDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    shareInstanceTileWidget(context, world.id, instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (ref.read(accessibilityConfigProvider).debugMode) openInJsonViewer(context, instance.content),
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
    shareUrlTileWidget(context, Uri.https("vrchat.com", "/home/user/${user.id}")),
    shareInstanceTileWidget(context, world.id, instance.instanceId),
    favoriteListTileWidget(context, world),
    selfInviteListTileWidget(context, instance),
    if (ref.read(accessibilityConfigProvider).debugMode) openInJsonViewer(context, instance.content),
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
    onTap: () {
      favoriteAction(context, world);
    },
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
