// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/main/friend_request.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

final currentIndexProvider = StateProvider<CurrentIndex>((ref) => CurrentIndex.online);

enum CurrentIndex {
  online(icon: Icons.wb_sunny),
  offline(icon: Icons.bedtime),
  search(icon: Icons.search),
  notify(icon: Icons.notifications),
  favorite(icon: Icons.favorite);

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
    return name;
  }

  final IconData icon;
  const CurrentIndex({required this.icon});
}

class VRChatMobileHome extends ConsumerWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    final CurrentIndex currentIndex = ref.watch(currentIndexProvider);
    final PageController controller = PageController(initialPage: currentIndex.index);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bottom Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheetConsumerWidget(
              context: context,
              builder: () => const GridModal(),
            ),
          ),
        ],
      ),
      drawer: drawer(),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [for (CurrentIndex scene in CurrentIndex.values) scene.toWidget()],
          onPageChanged: (int index) {
            ref.read(currentIndexProvider.notifier).state = CurrentIndex.values[index];
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for (CurrentIndex scene in CurrentIndex.values) BottomNavigationBarItem(icon: Icon(scene.icon), label: scene.toLocalization(context)),
        ],
        currentIndex: currentIndex.index,
        onTap: (int index) {
          ref.read(currentIndexProvider.notifier).state = CurrentIndex.values[index];
          controller.jumpToPage(index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
