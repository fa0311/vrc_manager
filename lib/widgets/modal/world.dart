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
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/lunch_world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/scroll.dart';

class WorldDetailsModalBottom extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const WorldDetailsModalBottom({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareUrlTileWidget(url: VRChatAssets.worlds.resolve(world.id)),
          FavoriteListTileWidget(world: world),
          LaunchWorldListTileWidget(world: world),
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
  final VRChatLimitedWorld world;
  final VRChatInstance instance;

  const UserInstanceDetailsModalBottom({super.key, required this.user, required this.world, required this.instance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareUrlTileWidget(url: VRChatAssets.user.resolve(user.id)),
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
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");

    return ListTile(
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () {
        vrchatLoginSession.selfInvite(instance.location, instance.shortName ?? "").catchError((e, trace) {
          logger.e(getMessage(e), e, trace);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
        });
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

final loadingWorldDataProvider = StateProvider<FavoriteWorldData?>((ref) => null);

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
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
    AsyncValue<VRChatMobileWorldFavoriteData> data = ref.watch(vrchatMobileWorldFavoriteSortProvider);
    FavoriteWorldData? loadingWorldData = ref.watch(loadingWorldDataProvider);

    return data.when(
      loading: () => const Loading(),
      error: (e, trace) {
        logger.w(getMessage(e), e, trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
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
                  return ListTile(
                    title: Text(favoriteData.group.displayName),
                    trailing: loadingWorldData == favoriteData
                        ? const Padding(
                            padding: EdgeInsets.only(right: 2, top: 2),
                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                          )
                        : favoriteWorldData == favoriteData
                            ? const Icon(Icons.check)
                            : null,
                    onTap: () async {
                      ref.read(loadingWorldDataProvider.notifier).state = favoriteData;
                      bool value = favoriteWorldData == favoriteData;
                      if (value || favoriteWorld != null) {
                        await vrchatLoginSession.deleteFavorites(favoriteWorld!.favoriteId).catchError((e, trace) {
                          logger.e(getMessage(e), e, trace);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
                        });
                        favoriteWorldData!.list.remove(favoriteWorld);
                        favoriteWorld = null;
                        favoriteWorldData = null;
                      }
                      if (!value && favoriteWorldData != favoriteData) {
                        VRChatFavorite favorite = await vrchatLoginSession.addFavorites("world", world.id, favoriteData.group.name).catchError((e, trace) {
                          logger.e(getMessage(e), e, trace);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
                        });
                        favoriteWorld = VRChatFavoriteWorld.fromFavorite(world, favorite, favoriteData.group.name);
                        favoriteData.list.add(favoriteWorld!);
                        favoriteWorldData = favoriteData;
                      }

                      ref.read(vrchatMobileWorldFavoriteCounterProvider.notifier).state++;
                      ref.read(loadingWorldDataProvider.notifier).state = null;
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
