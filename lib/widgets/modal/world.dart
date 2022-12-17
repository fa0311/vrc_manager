// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/world.dart';

List<Widget> worldDetailsModalBottom(
  VRChatWorld world,
) {
  return [
    ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/world/${world.id}")),
    FavoriteListTileWidget(world: world),
    LaunchWorldListTileWidget(world: world),
    OpenInJsonViewer(content: world.content),
  ];
}

List<Widget> instanceDetailsModalBottom(
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
    FavoriteListTileWidget(world: world),
    SelfInviteListTileWidget(instance: instance),
    OpenInJsonViewer(content: instance.content),
  ];
}

List<Widget> userInstanceDetailsModalBottom(
  VRChatUser user,
  VRChatWorld world,
  VRChatInstance instance,
) {
  return [
    ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/user/${user.id}")),
    ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
    FavoriteListTileWidget(world: world),
    SelfInviteListTileWidget(instance: instance),
    OpenInJsonViewer(content: instance.content),
  ];
}

class SelfInviteListTileWidget extends ConsumerWidget {
  final VRChatInstance instance;
  const SelfInviteListTileWidget({super.key, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () {
        selfInvite(context, instance);
      },
    );
  }
}

class FavoriteListTileWidget extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const FavoriteListTileWidget({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.addFavoriteWorlds),
      onTap: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () {
            return FavoriteAction(world: world);
          },
        );
      },
    );
  }
}

class LaunchWorldListTileWidget extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const LaunchWorldListTileWidget({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.launchWorld),
      onTap: () {
        launchWorld(context, world);
      },
    );
  }
}
