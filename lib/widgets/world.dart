// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/data_class/app_config.dart';

Widget onTheWebsite(
  BuildContext context, {
  bool half = false,
}) {
  return Container(
    alignment: Alignment.center,
    height: half ? 50 : 100,
    child: Text(AppLocalizations.of(context)!.onTheWebsite, style: TextStyle(fontSize: half ? 10 : 15)),
  );
}

showWorldLongPressModal(BuildContext context, AppConfig appConfig, VRChatInstance instance) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context)!.joinInstance),
            onTap: () {
              selfInvite(context, appConfig, instance);
            },
          ),
        ],
      ),
    ),
  );
}

void selfInvite(BuildContext context, AppConfig appConfig, VRChatInstance instance) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  vrchatLoginSession.selfInvite(instance.location, instance.shortName ?? "").then((VRChatNotificationsInvite response) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.sendInvite),
          content: Text(AppLocalizations.of(context)!.selfInviteDetails),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }).catchError((status) {
    apiError(context, appConfig, status);
  });
}

VRChatFavoriteWorld? getFavoriteWorld(AppConfig appConfig, VRChatWorld world) {
  for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
    for (VRChatFavoriteWorld favoriteWorld in favoriteWorld.list) {
      if (world.id == favoriteWorld.id) {
        return favoriteWorld;
      }
    }
  }
  return null;
}

FavoriteWorldData? getFavoriteData(AppConfig appConfig, VRChatWorld world) {
  for (FavoriteWorldData favoriteData in appConfig.loggedAccount?.favoriteWorld ?? []) {
    for (VRChatFavoriteWorld favoriteWorld in favoriteData.list) {
      if (world.id == favoriteWorld.id) {
        return favoriteData;
      }
    }
  }
  return null;
}

Widget favoriteAction(BuildContext context, AppConfig appConfig, VRChatWorld world) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatFavoriteWorld? favoriteWorld = getFavoriteWorld(appConfig, world);
  FavoriteWorldData? favoriteWorldData = getFavoriteData(appConfig, world);

  return IconButton(
    icon: const Icon(Icons.favorite),
    onPressed: () => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, Function setStateBuilder) => SingleChildScrollView(
          child: Column(
            children: [
              for (FavoriteWorldData favoriteData in appConfig.loggedAccount?.favoriteWorld ?? [])
                ListTile(
                  title: Text(favoriteData.group.displayName),
                  trailing: favoriteWorldData == favoriteData ? const Icon(Icons.check) : null,
                  onTap: () async {
                    if (favoriteWorldData == favoriteData || favoriteWorld != null) {
                      await vrchatLoginSession.deleteFavorites(favoriteWorld!.favoriteId).catchError((status) {
                        apiError(context, appConfig, status);
                      });
                      favoriteWorldData!.list.remove(favoriteWorld);
                    }
                    if (favoriteWorldData != favoriteData) {
                      await vrchatLoginSession.addFavorites("world", world.id, favoriteData.group.name).then((VRChatFavorite favoriteWorld) {
                        favoriteData.list.add(VRChatFavoriteWorld.fromFavorite(world, favoriteWorld, favoriteData.group.name));
                      }).catchError((status) {
                        apiError(context, appConfig, status);
                      });
                    }
                    /*
                    * To be fixed in the next stable version.
                    * if(context.mounted)
                    */
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
