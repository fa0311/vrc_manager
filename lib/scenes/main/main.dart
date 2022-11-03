// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/widgets/drawer.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class VRChatMobileHome extends ConsumerWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    final int currentIndex = ref.watch(currentIndexProvider);
    final PageController controller = PageController(initialPage: currentIndex);

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
          ],
          onPageChanged: (int index) => ref.read(currentIndexProvider.notifier).state = index,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'online'),
          BottomNavigationBarItem(icon: Icon(Icons.bedtime), label: 'offline'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          ref.read(currentIndexProvider.notifier).state = index;
          controller.jumpToPage(index);
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
