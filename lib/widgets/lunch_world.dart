// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/api/enum/region.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/region.dart';

String genRandHex([int length = 32]) {
  const charset = '0123456789ABCDEF';
  final random = Random.secure();
  final randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  return randomStr;
}

String genRandNumber([int length = 5]) {
  const charset = '0123456789';
  final random = Random.secure();
  final randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  return randomStr;
}

genInstanceId(BuildContext context, String region, String type, bool canRequestInvite) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatUserSelfOverload user = await vrchatLoginSession.user().catchError((status) {
    apiError(context, status);
  });
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

launchWorld(BuildContext context, VRChatLimitedWorld world) {
  List<Widget> children = [];
  for (VRChatRegion region in VRChatRegion.values) {
    children.add(
      ListTile(
        leading: RegionWidget(region: region),
        title: Text(region.name),
        onTap: () => selectWordType(context, world, region.name),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: children,
      ),
    ),
  );
}

selectWordType(BuildContext context, VRChatLimitedWorld world, String regionText) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext _) => SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.vrchatPublic),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              genInstanceId(context, regionText, "public", false)
                  .then((instanceId) => modalBottom(context, shareInstanceListTile(context, world.id, instanceId)));
            },
          ),
          ListTile(
              title: Text(AppLocalizations.of(context)!.vrchatFriendsPlus),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);

                genInstanceId(context, regionText, "hidden", false)
                    .then((instanceId) => modalBottom(context, shareInstanceListTile(context, world.id, instanceId)));
              }),
          ListTile(
              title: Text(AppLocalizations.of(context)!.vrchatFriends),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);

                genInstanceId(context, regionText, "friends", false)
                    .then((instanceId) => modalBottom(context, shareInstanceListTile(context, world.id, instanceId)));
              }),
          ListTile(
              title: Text(AppLocalizations.of(context)!.vrchatInvitePlus),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                genInstanceId(context, regionText, "private", true)
                    .then((instanceId) => modalBottom(context, shareInstanceListTile(context, world.id, instanceId)));
              }),
          ListTile(
              title: Text(AppLocalizations.of(context)!.vrchatInvite),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                genInstanceId(context, regionText, "private", false)
                    .then((instanceId) => modalBottom(context, shareInstanceListTile(context, world.id, instanceId)));
              })
        ],
      ),
    ),
  );
}
