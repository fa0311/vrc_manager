// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';

// Project imports:
import 'package:vrc_manager/scenes/sub/splash.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';

class VRChatMobileWorldFavoriteData {
  List<FavoriteWorldData> favoriteWorld;

  VRChatMobileWorldFavoriteData({required this.favoriteWorld});
}

class FavoriteWorldData {
  VRChatFavoriteGroup group;
  List<VRChatFavoriteWorld> list;

  FavoriteWorldData({required this.group, required this.list});
}

final vrchatMobileWorldFavoriteSortProvider = FutureProvider<VRChatMobileWorldFavoriteData>((ref) async {
  Future getFavoriteWorld(FavoriteWorldData favoriteWorld) async {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider)!.cookie);
    int len;
    do {
      int offset = favoriteWorld.list.length;
      List<VRChatFavoriteWorld> worlds = await vrchatLoginSession.favoritesWorlds(favoriteWorld.group.name, offset: offset);
      for (VRChatFavoriteWorld world in worlds) {
        favoriteWorld.list.add(world);
      }
      len = worlds.length;
    } while (len == 50);
  }

  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider)!.cookie);
  List<Future> futureList = [];
  List<FavoriteWorldData> favoriteWorld = [];
  int len = 0;
  do {
    int offset = favoriteWorld.length;
    List<VRChatFavoriteGroup> favoriteGroupList = await vrchatLoginSession.favoriteGroups("world", offset: offset);
    for (VRChatFavoriteGroup group in favoriteGroupList) {
      FavoriteWorldData favorite = FavoriteWorldData(group: group, list: []);
      futureList.add(getFavoriteWorld(favorite));
      favoriteWorld.add(favorite);
    }
    len = favoriteGroupList.length;
  } while (len == 50);

  await Future.wait(futureList);
  return VRChatMobileWorldFavoriteData(favoriteWorld: favoriteWorld);
});

class VRChatMobileWorldsFavorite extends ConsumerWidget {
  const VRChatMobileWorldsFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileWorldFavoriteData> data = ref.watch(vrchatMobileWorldFavoriteSortProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileWorldFavoriteSortProvider.future),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: data.when(
            loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (data) {
              return Column(children: [
                for (FavoriteWorldData favoriteWorld in data.favoriteWorld)
                  if (favoriteWorld.list.isNotEmpty) ...[
                    Text(favoriteWorld.group.displayName),
                    ExtractionFavoriteWorld(id: GridModalConfigType.favoriteWorlds, favoriteWorld: favoriteWorld.list),
                  ],
              ]);
            },
          ),
        ),
      ),
    );
  }
}
