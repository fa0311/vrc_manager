// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/user.dart';

class VRChatMobileSelfData {
  VRChatUserSelf user;
  VRChatUserSelfOverload data;
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatMobileSelfData({
    required this.user,
    required this.data,
    this.world,
    this.instance,
  });
}

final vrchatUserCountProvider = StateProvider<int>((ref) => 0);

final vrchatMobileSelfProvider = FutureProvider<VRChatMobileSelfData>((ref) async {
  final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.read(accountConfigProvider).loggedAccount!.cookie);
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatUserSelfOverload data = await vrchatLoginSession.user().catchError((e) {
    logger.e(getMessage(e), e);
  });

  VRChatUserSelf user = await vrchatLoginSession.selfUser(data.id).catchError((e) {
    logger.e(getMessage(e), e);
  });

  await vrchatLoginSession.users(user.id).then((value) => user.note = value.note).catchError((e) {
    logger.e(getMessage(e), e);
  });

  if (["private", "offline", "traveling"].contains(user.location)) return VRChatMobileSelfData(user: user, data: data);

  await Future.wait([
    vrchatLoginSession.worlds(user.location.split(":")[0]).then((value) => world = value).catchError((e) {
      logger.e(getMessage(e), e);
    }),
    vrchatLoginSession.instances(user.location).then((value) => instance = value).catchError((e) {
      logger.e(getMessage(e), e);
    }),
  ]);
  return VRChatMobileSelfData(user: user, data: data, world: world, instance: instance);
});

class VRChatMobileSelf extends ConsumerWidget {
  const VRChatMobileSelf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileSelfData> data = ref.watch(vrchatMobileSelfProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: data.when(
          loading: () => null,
          error: (e, trace) {
            logger.w(getMessage(e), e, trace);
            return null;
          },
          data: (data) => [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => SelfUserModalBottom(user: data.user),
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
                  error: (e, trace) {
                    logger.w(getMessage(e), e, trace);
                    return const ErrorPage();
                  },
                  data: (data) => Column(
                    children: [
                      UserProfile(user: data.user),
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
