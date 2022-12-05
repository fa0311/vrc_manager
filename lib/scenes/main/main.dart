// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/main/friend_request.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/widgets/drawer.dart';

final currentIndexProvider = StateProvider<CurrentIndex>((ref) => CurrentIndex.online);

enum CurrentIndex {
  online(icon: Icons.wb_sunny),
  offline(icon: Icons.bedtime),
  search(icon: Icons.search),
  notify(icon: Icons.notifications),
  favorite(icon: Icons.favorite);

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
      ),
      drawer: drawer(),
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            VRChatMobileFriends(offline: false),
            VRChatMobileFriends(offline: true),
            VRChatMobileSearch(),
            VRChatMobileFriendRequest(),
            VRChatMobileWorldsFavorite(),
          ],
          onPageChanged: (int index) => ref.read(currentIndexProvider.notifier).state = CurrentIndex.values[index],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'online'),
          BottomNavigationBarItem(icon: Icon(Icons.bedtime), label: 'offline'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'notify'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'favorite'),
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
