// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/scenes/main/friend_request.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_modal/modal.dart';
import 'package:vrc_manager/widgets/modal.dart';

final currentIndexProvider = StateProvider<CurrentIndex>((ref) => CurrentIndex.online);
final gridModalConfigIdProvider = StateProvider<GridModalConfigType>((ref) => GridModalConfigType.onlineFriends);

enum CurrentIndex {
  online(icon: Icons.wb_sunny),
  offline(icon: Icons.bedtime),
  search(icon: Icons.search),
  favorite(icon: Icons.favorite),
  notify(icon: Icons.notifications);

  Widget toWidget() {
    switch (this) {
      case CurrentIndex.online:
        return const VRChatMobileFriends(offline: false);
      case CurrentIndex.offline:
        return const VRChatMobileFriends(offline: true);
      case CurrentIndex.search:
        return const VRChatMobileSearch();
      case CurrentIndex.notify:
        return const VRChatMobileFriendRequest();
      case CurrentIndex.favorite:
        return const VRChatMobileWorldsFavorite();
    }
  }

  String toLocalization(BuildContext context) {
    switch (this) {
      case CurrentIndex.online:
        return AppLocalizations.of(context)!.onlineFriends;
      case CurrentIndex.offline:
        return AppLocalizations.of(context)!.offlineFriends;
      case CurrentIndex.search:
        return AppLocalizations.of(context)!.search;
      case CurrentIndex.favorite:
        return AppLocalizations.of(context)!.favoriteWorlds;
      case CurrentIndex.notify:
        return AppLocalizations.of(context)!.friendRequest;
    }
  }

  final IconData icon;
  const CurrentIndex({required this.icon});
}

class VRChatMobileHome extends ConsumerWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CurrentIndex currentIndex = ref.watch(currentIndexProvider);
    final PageController controller = PageController(initialPage: currentIndex.index);

    getGridConfig(CurrentIndex currentIndex) {
      switch (currentIndex) {
        case CurrentIndex.online:
          return GridModalConfigType.onlineFriends;
        case CurrentIndex.offline:
          return GridModalConfigType.offlineFriends;
        case CurrentIndex.notify:
          return GridModalConfigType.friendsRequest;
        case CurrentIndex.search:
          switch (ref.read(vrchatMobileSearchModeProvider)) {
            case SearchMode.users:
              return GridModalConfigType.searchUsers;
            case SearchMode.worlds:
              return GridModalConfigType.searchWorlds;
          }
        case CurrentIndex.favorite:
          return GridModalConfigType.favoriteWorlds;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentIndex.toLocalization(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => GridModal(type: ref.read(gridModalConfigIdProvider)),
            ),
          ),
        ],
      ),
      drawer: const NormalDrawer(),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [for (CurrentIndex scene in CurrentIndex.values) scene.toWidget()],
          onPageChanged: (int index) {
            ref.read(currentIndexProvider.notifier).state = CurrentIndex.values[index];
            ref.read(gridModalConfigIdProvider.notifier).state = getGridConfig(CurrentIndex.values[index]);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (CurrentIndex scene in CurrentIndex.values) BottomNavigationBarItem(icon: Icon(scene.icon), label: scene.toLocalization(context)),
        ],
        currentIndex: currentIndex.index,
        onTap: (int index) => controller.jumpToPage(index),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
