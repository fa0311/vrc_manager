// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';

class OnTheWebsite extends ConsumerWidget {
  final bool half;
  const OnTheWebsite({super.key, this.half = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      height: half ? 50 : 100,
      child: Text(AppLocalizations.of(context)!.onTheWebsite, style: TextStyle(fontSize: half ? 10 : 15)),
    );
  }
}

class WorldProfile extends ConsumerWidget {
  final VRChatWorld world;
  const WorldProfile({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 250,
          child: CachedNetworkImage(
            imageUrl: world.imageUrl,
            fit: BoxFit.fitWidth,
            progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
              width: 250.0,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const SizedBox(
              width: 250.0,
              child: Icon(Icons.error),
            ),
          ),
        ),
        Text(world.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Text(world.description ?? ""),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.occupants(
            world.occupants,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.privateOccupants(
            world.privateOccupants,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.favorites(
            world.favorites,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.createdAt(
            generalDateDifference(context, world.createdAt),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.updatedAt(
            generalDateDifference(context, world.updatedAt),
          ),
        ),
      ],
    );
  }
}

Future selfInvite({required VRChatAPI vrchatLoginSession, required VRChatInstance instance}) async {
  await vrchatLoginSession.selfInvite(instance.location, instance.shortName ?? "");
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
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider)!.cookie);
    AsyncValue<VRChatMobileWorldFavoriteData> data = ref.watch(vrchatMobileWorldFavoriteSortProvider);

    FavoriteWorldData? loadingWorldData;

    return data.when(
      loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
      data: (data) {
        return Column(
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
                    loadingWorldData = favoriteData;
                    bool value = favoriteWorldData == favoriteData;
                    if (value || favoriteWorld != null) {
                      await vrchatLoginSession.deleteFavorites(favoriteWorld!.favoriteId);
                      favoriteWorldData!.list.remove(favoriteWorld);
                      favoriteWorld = null;
                      favoriteWorldData = null;
                    }
                    if (!value && favoriteWorldData != favoriteData) {
                      await vrchatLoginSession.addFavorites("world", world.id, favoriteData.group.name).then((VRChatFavorite favorite) {
                        favoriteWorld = VRChatFavoriteWorld.fromFavorite(world, favorite, favoriteData.group.name);
                        favoriteData.list.add(favoriteWorld!);
                        favoriteWorldData = favoriteData;
                      }).catchError((status) {
                        apiError(context, status);
                      });
                    }
                    loadingWorldData = null;
                  },
                );
              }(),
          ],
        );
      },
    );
  }
}
