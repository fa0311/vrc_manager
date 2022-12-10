// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';

class VRChatMobileWorldFavoriteData {
  List<FavoriteWorldData> worldList;
  VRChatMobileWorldFavoriteData({required this.worldList});
}

final vrchatMobileWorldFavoriteSortProvider = FutureProvider<VRChatMobileWorldFavoriteData>((ref) async {
  VRChatMobileWorldFavoriteData data = VRChatMobileWorldFavoriteData(worldList: appConfig.loggedAccount?.favoriteWorld ?? []);
  return data;
});

class VRChatMobileWorldsFavorite extends ConsumerWidget {
  const VRChatMobileWorldsFavorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileWorldFavoriteData> data = ref.watch(vrchatMobileWorldFavoriteSortProvider);

    return SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, child) {
          return data.when(
            loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
            data: (data) {
              return Column(children: [
                for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? [])
                  if (favoriteWorld.list.isNotEmpty) ...[
                    Text(favoriteWorld.group.displayName),
                    ExtractionFavoriteWorld(id: GridConfigId.favoriteWorlds, favoriteWorld: favoriteWorld.list),
                  ],
              ]);
            },
          );
        },
      ),
    );
  }
}
