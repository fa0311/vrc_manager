// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/enum/region.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/region.dart';

String genRandHex([int length = 32]) {
  const String charset = '0123456789ABCDEF';
  Random random = Random.secure();
  String randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  return randomStr;
}

String genRandNumber([int length = 5]) {
  const String charset = '0123456789';
  Random random = Random.secure();
  String randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  return randomStr;
}

Future<String> genInstanceId({required VRChatAPI vrchatLoginSession, required String region, required String type, required bool canRequestInvite}) async {
  VRChatUserSelfOverload user = await vrchatLoginSession.user();
  String url = genRandNumber();

  if (["hidden", "friends", "private"].contains(type)) {
    url += "~$type(${user.id})";
  }
  if (canRequestInvite) {
    url += "~canRequestInvite";
  }
  url += "~region($region)";
  if (["hidden", "friends", "private"].contains(type)) {
    url += "~nonce(${genRandHex(48)})";
  }
  return url;
}

class LaunchWorld extends ConsumerWidget {
  final VRChatLimitedWorld world;
  const LaunchWorld({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (VRChatRegion region in VRChatRegion.values)
            ListTile(
              leading: RegionWidget(region: region),
              title: Text(region.name),
              onTap: () => showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => SelectWordType(world: world, regionText: region.name),
              ),
            ),
        ],
      ),
    );
  }
}

class SelectWordType extends ConsumerWidget {
  final VRChatLimitedWorld world;
  final String regionText;

  const SelectWordType({super.key, required this.world, required this.regionText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatPublic),
            onTap: () async {
              String instanceId = await genInstanceId(vrchatLoginSession: vrchatLoginSession, region: regionText, type: "public", canRequestInvite: false);
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareInstanceListTile(worldId: world.id, instanceId: instanceId),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatFriendsPlus),
            onTap: () async {
              String instanceId = await genInstanceId(vrchatLoginSession: vrchatLoginSession, region: regionText, type: "hidden", canRequestInvite: false);
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareInstanceListTile(worldId: world.id, instanceId: instanceId),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatFriends),
            onTap: () async {
              String instanceId = await genInstanceId(vrchatLoginSession: vrchatLoginSession, region: regionText, type: "friends", canRequestInvite: false);
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareInstanceListTile(worldId: world.id, instanceId: instanceId),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatInvitePlus),
            onTap: () async {
              String instanceId = await genInstanceId(vrchatLoginSession: vrchatLoginSession, region: regionText, type: "private", canRequestInvite: true);
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareInstanceListTile(worldId: world.id, instanceId: instanceId),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatInvite),
            onTap: () async {
              String instanceId = await genInstanceId(vrchatLoginSession: vrchatLoginSession, region: regionText, type: "private", canRequestInvite: false);
              Navigator.of(context).popUntil((route) => route.isFirst);
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareInstanceListTile(worldId: world.id, instanceId: instanceId),
              );
            },
          )
        ],
      ),
    );
  }
}
