// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/future/tile.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/scroll.dart';

class WorldDetailsModalBottom extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const WorldDetailsModalBottom({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (world is VRChatFavoriteWorld) FavoriteRemoveTileWidget(favoriteWorld: world as VRChatFavoriteWorld),
          LaunchWorldListTileWidget(world: world),
          FavoriteListTileWidget(world: world),
          if (world.id != "???") ShareUrlTileWidget(url: VRChatAssets.worlds.resolve(world.id)),
          OpenInJsonViewer(content: world.content),
        ],
      ),
    );
  }
}

class InstanceDetailsModalBottom extends ConsumerWidget {
  final VRChatLimitedWorld world;
  final VRChatInstance instance;

  const InstanceDetailsModalBottom({super.key, required this.world, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SelfInviteListTileWidget(instance: instance),
          FavoriteListTileWidget(world: world),
          ShareInstanceTileWidget(worldId: world.id, instanceId: instance.instanceId),
          OpenInJsonViewer(content: instance.content),
        ],
      ),
    );
  }
}

class UserInstanceDetailsModalBottom extends ConsumerWidget {
  final VRChatUser user;
  final VRChatLimitedWorld world;
  final VRChatInstance instance;

  const UserInstanceDetailsModalBottom({super.key, required this.user, required this.world, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatFriendStatus userStatus = VRChatFriendStatus(isFriend: false, incomingRequest: false, outgoingRequest: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          EditNoteTileWidget(user: user),
          ProfileActionTileWidget(status: userStatus, user: user),
          FavoriteListTileWidget(world: world),
          SelfInviteListTileWidget(instance: instance),
          ShareUrlTileWidget(url: VRChatAssets.user.resolve(user.id)),
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
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
      userAgent: ref.watch(accountConfigProvider).userAgent,
      logger: logger,
    );

    return FutureTile(
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () async {
        try {
          await vrchatLoginSession.selfInvite(instance.location, instance.shortName ?? "");
        } catch (e, trace) {
          logger.e(getMessage(e), e, trace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
        }
      },
    );
  }
}

class FavoriteListTileWidget extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const FavoriteListTileWidget({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (world.id == "???") return Container();
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

class FavoriteRemoveTileWidget extends ConsumerWidget {
  final VRChatFavoriteWorld favoriteWorld;
  const FavoriteRemoveTileWidget({super.key, required this.favoriteWorld});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (favoriteWorld.id != "???") return Container();
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
      userAgent: ref.watch(accountConfigProvider).userAgent,
      logger: logger,
    );
    return FutureTile(
      title: Text(AppLocalizations.of(context)!.removeFavoriteWorlds),
      onTap: () async {
        try {
          await vrchatLoginSession.deleteFavorites(favoriteWorld.favoriteId);
        } catch (e, trace) {
          logger.e(getMessage(e), e, trace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
        }
      },
    );
  }
}

class LaunchWorldListTileWidget extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const LaunchWorldListTileWidget({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (world.id == "???") return Container();
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

class FavoriteAction extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const FavoriteAction({super.key, required this.world});

  VRChatFavoriteWorld? getFavoriteWorld(List<FavoriteWorldData> favoriteWorld) {
    for (FavoriteWorldData favoriteWorld in favoriteWorld) {
      for (VRChatFavoriteWorld favoriteWorld in favoriteWorld.list) {
        if (world.id == favoriteWorld.id) {
          return favoriteWorld;
        }
      }
    }
    return null;
  }

  FavoriteWorldData? getFavoriteData(List<FavoriteWorldData> favoriteWorld) {
    for (FavoriteWorldData favoriteData in favoriteWorld) {
      for (VRChatFavoriteWorld favoriteWorld in favoriteData.list) {
        if (world.id == favoriteWorld.id) {
          return favoriteData;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
      userAgent: ref.watch(accountConfigProvider).userAgent,
      logger: logger,
    );
    final data = ref.watch(vrchatMobileWorldFavoriteSortProvider);

    return data.when(
      loading: () => const Loading(),
      error: (e, trace) {
        logger.w(getMessage(e), e, trace);
        return ScrollWidget(
          onRefresh: () => ref.refresh((vrchatMobileWorldFavoriteSortProvider.future)),
          child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
        );
      },
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              for (FavoriteWorldData favoriteData in data.favoriteWorld)
                () {
                  VRChatFavoriteWorld? favoriteWorld = getFavoriteWorld(data.favoriteWorld);
                  FavoriteWorldData? favoriteWorldData = getFavoriteData(data.favoriteWorld);
                  ref.watch(vrchatMobileWorldFavoriteCounterProvider);
                  return FutureTile(
                    title: Text(favoriteData.group.displayName),
                    trailing: favoriteWorldData == favoriteData ? const Icon(Icons.check) : null,
                    onTap: () async {
                      try {
                        bool value = favoriteWorldData == favoriteData;
                        if (value || favoriteWorld != null) {
                          await vrchatLoginSession.deleteFavorites(favoriteWorld!.favoriteId);
                          favoriteWorldData!.list.remove(favoriteWorld);
                          favoriteWorld = null;
                          favoriteWorldData = null;
                        }
                        if (!value && favoriteWorldData != favoriteData) {
                          VRChatFavorite favorite = await vrchatLoginSession.addFavorites("world", world.id, favoriteData.group.name);
                          favoriteWorld = VRChatFavoriteWorld.fromFavorite(world, favorite, favoriteData.group.name);
                          favoriteData.list.add(favoriteWorld!);
                          favoriteWorldData = favoriteData;
                        }
                        ref.read(vrchatMobileWorldFavoriteCounterProvider.notifier).state++;
                      } catch (e, trace) {
                        logger.e(getMessage(e), e, trace);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
                      }
                    },
                  );
                }(),
            ],
          ),
        );
      },
    );
  }
}
