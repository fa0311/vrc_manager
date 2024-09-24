// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/assets/instance_type.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/scroll.dart';
import 'package:vrc_manager/widgets/user.dart';

class VRChatMobileSelfData {
  VRChatUserSelf user;
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatMobileSelfData({
    required this.user,
    this.world,
    this.instance,
  });
}

final vrchatUserCountProvider = StateProvider<int>((ref) => 0);

final vrchatMobileSelfProvider = FutureProvider<VRChatMobileSelfData>((ref) async {
  final VRChatAPI vrchatLoginSession = VRChatAPI(
    cookie: ref.read(accountConfigProvider).loggedAccount!.cookie ?? "",
    userAgent: ref.watch(accountConfigProvider).userAgent,
    logger: logger,
  );
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatUserSelf user = await vrchatLoginSession.selfUser(ref.read(accountConfigProvider).loggedAccount?.data?.id ?? "");

  if (VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return VRChatMobileSelfData(user: user);

  await Future.wait([
    vrchatLoginSession.worlds(user.location.split(":")[0]).then((value) => world = value),
    vrchatLoginSession.instances(user.location).then((value) => instance = value),
  ]);

  return VRChatMobileSelfData(user: user, world: world, instance: instance);
});

class VRChatMobileSelf extends ConsumerWidget {
  const VRChatMobileSelf({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileSelfData> data = ref.watch(vrchatMobileSelfProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user),
        actions: data.when(
          loading: () => null,
          error: (e, trace) {
            logger.w(getMessage(e), error: e, stackTrace: trace);
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
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(vrchatUserCountProvider);
            return data.when(
              loading: () => const Loading(),
              error: (e, trace) {
                logger.w(getMessage(e), error: e, stackTrace: trace);
                return ScrollWidget(
                  onRefresh: () => ref.refresh(vrchatMobileSelfProvider.future),
                  child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
                );
              },
              data: (data) => ScrollWidget(
                onRefresh: () => ref.refresh(vrchatMobileSelfProvider.future),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
                  child: Column(
                    children: [
                      UserProfile(user: data.user),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: () {
                          if (data.user.location == VRChatInstanceIdOther.private.name) return const PrivateWorld();
                          if (data.user.location == VRChatInstanceIdOther.traveling.name) return const TravelingWorld();
                          if (data.user.location == VRChatInstanceIdOther.offline.name) return null;
                          return data.world == null ? null : InstanceWidget(world: data.world!, instance: data.instance!);
                        }(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
