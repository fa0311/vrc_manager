// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/world.dart';
import 'package:vrc_manager/widgets/world.dart';

class VRChatMobileWorldData {
  VRChatWorld world;

  VRChatMobileWorldData({
    required this.world,
  });
}

final vrchatMobileUserProvider = FutureProvider.family<VRChatMobileWorldData, String>((ref, worldId) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);

  late VRChatWorld world;
  await vrchatLoginSession.worlds(worldId).then((value) => world = value).catchError((e) {
    logger.e(e);
  });
  return VRChatMobileWorldData(world: world);
});

class VRChatMobileWorld extends ConsumerWidget {
  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);
  final String worldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileWorldData> data = ref.watch(vrchatMobileUserProvider(worldId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.world),
        actions: data.when(
          loading: () => null,
          error: (err, stack) {
            logger.w(err, err, stack);
            return null;
          },
          data: (data) => [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => WorldDetailsModalBottom(world: data.world),
                );
              },
            )
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
                return data.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) {
                    logger.w(err, err, stack);
                    return const ErrorPage();
                  },
                  data: (data) => WorldProfile(world: data.world),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
