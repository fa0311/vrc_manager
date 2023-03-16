// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/render_grid/favorite_world.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/scroll.dart';

class VRChatMobileWorldFavoriteData {
  List<FavoriteWorldData> favoriteWorld;

  VRChatMobileWorldFavoriteData({required this.favoriteWorld});
}

class FavoriteWorldData {
  VRChatFavoriteGroup group;
  List<VRChatFavoriteWorld> list;

  FavoriteWorldData({required this.group, required this.list});
}

final vrchatMobileWorldFavoriteCounterProvider = StateProvider<int>((ref) => 0);

final vrchatMobileWorldFavoriteSortProvider = FutureProvider<VRChatMobileWorldFavoriteData>((ref) async {
  Future getFavoriteWorld(FavoriteWorldData favoriteWorld) async {
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
      userAgent: ref.watch(accountConfigProvider).userAgent,
      logger: logger,
    );
    int len;
    do {
      int offset = favoriteWorld.list.length;
      List<VRChatFavoriteWorld> worlds = await vrchatLoginSession.favoritesWorlds(favoriteWorld.group.name, offset: offset).catchError((e, trace) {
        logger.e(getMessage(e), e, trace);
      });
      for (VRChatFavoriteWorld world in worlds) {
        favoriteWorld.list.add(world);
      }
      len = worlds.length;
    } while (len > 0);
  }

  VRChatAPI vrchatLoginSession = VRChatAPI(
    cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
    userAgent: ref.watch(accountConfigProvider).userAgent,
    logger: logger,
  );
  List<Future> futureList = [];
  List<FavoriteWorldData> favoriteWorld = [];
  int len = 0;
  do {
    int offset = favoriteWorld.length;
    List<VRChatFavoriteGroup> favoriteGroupList = await vrchatLoginSession.favoriteGroups("world", offset: offset).catchError((e, trace) {
      logger.e(getMessage(e), e, trace);
    });
    for (VRChatFavoriteGroup group in favoriteGroupList) {
      FavoriteWorldData favorite = FavoriteWorldData(group: group, list: []);
      futureList.add(getFavoriteWorld(favorite));
      favoriteWorld.add(favorite);
    }
    len = favoriteGroupList.length;
  } while (len > 0);

  await Future.wait(futureList);
  return VRChatMobileWorldFavoriteData(favoriteWorld: favoriteWorld);
});

class VRChatMobileWorldsFavorite extends ConsumerWidget {
  const VRChatMobileWorldsFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileWorldFavoriteData> data = ref.watch(vrchatMobileWorldFavoriteSortProvider);
    ref.watch(vrchatMobileWorldFavoriteCounterProvider);

    return data.when(
      loading: () => const Loading(),
      error: (e, trace) {
        logger.w(getMessage(e), e, trace);
        return ScrollWidget(
          onRefresh: () => ref.refresh(vrchatMobileWorldFavoriteSortProvider.future),
          child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
        );
      },
      data: (data) {
        return ScrollWidget(
          onRefresh: () => ref.refresh(vrchatMobileWorldFavoriteSortProvider.future),
          child: Column(
            children: [
              for (FavoriteWorldData favoriteWorld in data.favoriteWorld)
                if (favoriteWorld.list.isNotEmpty) ...[
                  Text(favoriteWorld.group.displayName),
                  ExtractionFavoriteWorld(id: GridModalConfigType.favoriteWorlds, favoriteWorld: favoriteWorld.list),
                ],
            ],
          ),
        );
      },
    );
  }
}
