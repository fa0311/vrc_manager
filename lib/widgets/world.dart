// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';
import 'package:vrchat_mobile_client/widgets/template.dart';

Widget instanceWidget(
  BuildContext context,
  AppConfig appConfig,
  VRChatWorld world,
  VRChatInstance instance, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    imageUrl: world.thumbnailImageUrl,
    card: card,
    half: half,
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
        )),
    onLongPress: () => showWorldLongPressModal(context, appConfig, instance),
    children: [
      Row(children: <Widget>[
        region(instance.region, size: half ? 12 : 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Icon(Icons.groups, size: half ? 17 : 25),
              Text("${instance.nUsers}/${instance.capacity}",
                  style: TextStyle(
                    fontSize: half ? 10 : 15,
                  )),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Text(getVrchatInstanceType(context)[instance.type] ?? "Error",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: half ? 10 : 15,
                )),
          ),
        )
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            world.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: half ? 10 : 15,
              height: 1,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget privateWorld(
  BuildContext context,
  AppConfig appConfig, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    card: card,
    half: half,
    children: [
      SizedBox(
        width: double.infinity,
        child: Text("Private",
            style: TextStyle(
              fontSize: half ? 10 : 15,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context)!.privateWorld,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: half ? 10 : 15,
            ),
          ),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
  );
}

Widget travelingWorld(
  BuildContext context,
  AppConfig appConfig, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    card: card,
    half: half,
    children: [
      SizedBox(
        width: double.infinity,
        child: Text("Traveling",
            style: TextStyle(
              fontSize: half ? 10 : 15,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context)!.privateWorld,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: half ? 10 : 15,
            ),
          ),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/normalbetween_image.png",
  );
}

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
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  vrhatLoginSession.selfInvite(instance.location, instance.shortName ?? "").then((VRChatNotificationsInvite response) {
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

Widget favoriteAction(BuildContext context, AppConfig appConfig, VRChatWorld world) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatFavoriteWorld? favoritedWorld;
  FavoriteWorldData? favoritedWorldData;

  () {
    for (FavoriteWorldData favoriteWorldData in appConfig.loggedAccount?.favoriteWorld ?? []) {
      for (VRChatFavoriteWorld favoriteWorld in favoriteWorldData.list) {
        if (world.id == favoriteWorld.id) {
          favoritedWorld = favoriteWorld;
          return favoritedWorldData = favoriteWorldData;
        }
      }
    }
  }();
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
              for (FavoriteWorldData favoriteWorldData in appConfig.loggedAccount?.favoriteWorld ?? [])
                ListTile(
                  title: Text(favoriteWorldData.group.displayName),
                  trailing: favoritedWorldData == favoriteWorldData ? const Icon(Icons.check) : null,
                  onTap: () async {
                    if (favoritedWorldData == favoriteWorldData || favoritedWorld != null) {
                      await vrhatLoginSession.deleteFavorites(favoritedWorld!.favoriteId).catchError((status) {
                        apiError(context, appConfig, status);
                      });
                      favoritedWorldData!.list.remove(favoritedWorld!);
                    }
                    if (favoritedWorldData != favoriteWorldData) {
                      await vrhatLoginSession.addFavorites("world", world.id, favoriteWorldData.group.name).then((VRChatFavorite favoriteWorld) {
                        favoriteWorldData.list.add(VRChatFavoriteWorld.fromFavorite(world, favoriteWorld, favoriteWorldData.group.name));
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
