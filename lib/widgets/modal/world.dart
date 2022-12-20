// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/world.dart';

class WorldDetailsModalBottom extends ConsumerWidget {
  final VRChatWorld world;
  const WorldDetailsModalBottom({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/world/${world.id}")),
          FavoriteListTileWidget(world: world),
          LaunchWorldListTileWidget(world: world),
          OpenInJsonViewer(content: world.content),
        ],
      ),
    );
  }
}

class InstanceDetailsModalBottom extends ConsumerWidget {
  final VRChatWorld world;
  final VRChatInstance instance;

  const InstanceDetailsModalBottom({super.key, required this.world, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
          FavoriteListTileWidget(world: world),
          SelfInviteListTileWidget(instance: instance),
          OpenInJsonViewer(content: instance.content),
        ],
      ),
    );
  }
}

class UserInstanceDetailsModalBottom extends ConsumerWidget {
  final VRChatUser user;
  final VRChatWorld world;
  final VRChatInstance instance;

  const UserInstanceDetailsModalBottom({super.key, required this.user, required this.world, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareUrlTileWidget(url: Uri.https("vrchat.com", "/home/user/${user.id}")),
          ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
          FavoriteListTileWidget(world: world),
          SelfInviteListTileWidget(instance: instance),
          OpenInJsonViewer(content: instance.content),
        ],
      ),
    );
  }
}

class SelfInviteListTileWidget extends ConsumerWidget {
  final VRChatInstance instance;
  const SelfInviteListTileWidget({super.key, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () {
        selfInvite(vrchatLoginSession: vrchatLoginSession, instance: instance);
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
          builder: () => FavoriteAction(world: world),
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
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () => LaunchWorld(world: world),
        );
      },
    );
  }
}
