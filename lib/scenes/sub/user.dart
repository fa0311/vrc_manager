// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/sub/self.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/user.dart';

class VRChatMobileUserData {
  VRChatUser user;
  VRChatFriendStatus status;
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatMobileUserData({
    required this.user,
    required this.status,
    this.world,
    this.instance,
  });
}

final vrchatMobileUserProvider = FutureProvider.family<VRChatMobileUserData, String>((ref, userId) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);
  late VRChatUser user;
  late VRChatFriendStatus status;
  VRChatWorld? world;
  VRChatInstance? instance;

  await Future.wait([
    vrchatLoginSession.users(userId).then((value) => user = value),
    vrchatLoginSession.friendStatus(userId).then((value) => status = value),
  ]);
  if (["private", "offline", "traveling"].contains(user.location)) return VRChatMobileUserData(user: user, status: status);

  await Future.wait([
    vrchatLoginSession.worlds(user.location.split(":")[0]).then((value) => world = value),
    vrchatLoginSession.instances(user.location).then((value) => instance = value),
  ]);
  return VRChatMobileUserData(user: user, status: status, world: world, instance: instance);
});

class VRChatMobileUser extends ConsumerWidget {
  const VRChatMobileUser({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileUserData> data = ref.watch(vrchatMobileUserProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: data.when(
          loading: () => null,
          error: (err, stack) => null,
          data: (data) => [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => UserDetailsModalBottom(user: data.user, status: data.status),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Navigator.of(context).canPop() ? null : const NormalDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 0,
              right: 30,
              left: 30,
            ),
            child: Consumer(
              builder: (context, ref, child) {
                ref.watch(vrchatUserCountProvider);
                return data.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                  data: (data) => Column(
                    children: [
                      userProfile(context, data.user),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: () {
                          if (data.user.location == "private") return const PrivateWorld();
                          if (data.user.location == "traveling") return const TravelingWorld();
                          if (data.user.location == "offline") return null;
                          return data.world == null ? null : InstanceWidget(world: data.world!, instance: data.instance!);
                        }(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
