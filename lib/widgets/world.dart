// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';

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

Column worldProfile(BuildContext context, VRChatWorld world) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 250,
        child: CachedNetworkImage(
          imageUrl: world.imageUrl,
          fit: BoxFit.fitWidth,
          progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
            width: 250.0,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox(
            width: 250.0,
            child: Icon(Icons.error),
          ),
        ),
      ),
      Text(world.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: Text(world.description ?? ""),
        ),
      ),
      Text(
        AppLocalizations.of(context)!.occupants(
          world.occupants,
        ),
      ),
      Text(
        AppLocalizations.of(context)!.privateOccupants(
          world.privateOccupants,
        ),
      ),
      Text(
        AppLocalizations.of(context)!.favorites(
          world.favorites,
        ),
      ),
      Text(
        AppLocalizations.of(context)!.createdAt(
          generalDateDifference(context, world.createdAt),
        ),
      ),
      Text(
        AppLocalizations.of(context)!.updatedAt(
          generalDateDifference(context, world.updatedAt),
        ),
      ),
    ],
  );
}

Future selfInvite(BuildContext context, VRChatInstance instance) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  return await vrchatLoginSession.selfInvite(instance.location, instance.shortName ?? "").then((VRChatNotificationsInvite response) {
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
    apiError(context, status);
  });
}

VRChatFavoriteWorld? getFavoriteWorld(VRChatLimitedWorld world) {
  for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
    for (VRChatFavoriteWorld favoriteWorld in favoriteWorld.list) {
      if (world.id == favoriteWorld.id) {
        return favoriteWorld;
      }
    }
  }
  return null;
}

FavoriteWorldData? getFavoriteData(VRChatLimitedWorld world) {
  for (FavoriteWorldData favoriteData in appConfig.loggedAccount?.favoriteWorld ?? []) {
    for (VRChatFavoriteWorld favoriteWorld in favoriteData.list) {
      if (world.id == favoriteWorld.id) {
        return favoriteData;
      }
    }
  }
  return null;
}

Future favoriteAction(BuildContext context, VRChatLimitedWorld world, {Function? setState}) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatFavoriteWorld? favoriteWorld = getFavoriteWorld(world);
  FavoriteWorldData? favoriteWorldData = getFavoriteData(world);
  FavoriteWorldData? loadingWorldData;
  setState ??= (fn) => fn();
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => Column(
          children: [
            for (FavoriteWorldData favoriteData in appConfig.loggedAccount?.favoriteWorld ?? [])
              ListTile(
                title: Text(favoriteData.group.displayName),
                trailing: loadingWorldData == favoriteData
                    ? const Padding(
                        padding: EdgeInsets.only(right: 2, top: 2),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                      )
                    : favoriteWorldData == favoriteData
                        ? const Icon(Icons.check)
                        : null,
                onTap: () async {
                  loadingWorldData = favoriteData;
                  setStateBuilder(() {});
                  bool value = favoriteWorldData == favoriteData;
                  if (value || favoriteWorld != null) {
                    await vrchatLoginSession.deleteFavorites(favoriteWorld!.favoriteId).catchError((status) {
                      apiError(context, status);
                    });
                    favoriteWorldData!.list.remove(favoriteWorld);
                    favoriteWorld = null;
                    favoriteWorldData = null;
                  }
                  if (!value && favoriteWorldData != favoriteData) {
                    await vrchatLoginSession.addFavorites("world", world.id, favoriteData.group.name).then((VRChatFavorite favorite) {
                      favoriteWorld = VRChatFavoriteWorld.fromFavorite(world, favorite, favoriteData.group.name);
                      favoriteData.list.add(favoriteWorld!);
                      favoriteWorldData = favoriteData;
                    }).catchError((status) {
                      apiError(context, status);
                    });
                  }
                  loadingWorldData = null;
                  setStateBuilder(() {});
                  setState!(() {});
                },
              ),
          ],
        ),
      ),
    ),
  );
}
