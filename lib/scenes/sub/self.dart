// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/notifier.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/user.dart';
import 'package:vrc_manager/widgets/user.dart';

class VRChatMobileSelfData {
  VRChatUserSelfOverload user;
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatMobileSelfData({
    required this.user,
    this.world,
    this.instance,
  });
}

final vrchatMobileSelfProvider = FutureProvider<VRChatMobileSelfData>((ref) async {
  final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late VRChatUserSelfOverload user;
  VRChatWorld? world;
  VRChatInstance? instance;

  await Future.wait([
    vrchatLoginSession.user().then((value) => user = value),
  ]);
  await Future.wait([
    vrchatLoginSession.users(user.id).then((value) => user.note = value.note),
  ]);
  if (["private", "offline", "traveling"].contains(user.location)) return VRChatMobileSelfData(user: user);

  await Future.wait([
    vrchatLoginSession.worlds(user.location.split(":")[0]).then((value) => world = value),
    vrchatLoginSession.instances(user.location).then((value) => instance = value),
  ]);
  return VRChatMobileSelfData(user: user, world: world, instance: instance);
});

class VRChatMobileSelf extends ConsumerWidget {
  const VRChatMobileSelf({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileSelfData> data = ref.watch(vrchatMobileSelfProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: data.when(
          loading: () => null,
          error: (err, stack) => null,
          data: (data) => [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => modalBottom(
                context,
                selfUserModalBottom(context, ref, data.user),
              ),
            ),
          ],
        ),
      ),
      drawer: Navigator.of(context).canPop() ? null : drawer(),
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
                ref.watch(vrchatUserNotifier);
                return data.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error: $err'),
                  data: (data) => Column(
                    children: [
                      userProfile(context, ref.read(vrchatUserNotifier).user ?? data.user),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: () {
                          if (data.user.location == "private") return privateWorld(context);
                          if (data.user.location == "traveling") return privateWorld(context);
                          if (data.user.location == "offline") return null;
                          return data.world == null ? null : instanceWidget(context, data.world!, data.instance!);
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
