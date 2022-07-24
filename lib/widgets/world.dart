// Flutter imports:

// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/scenes/worlds_favorite.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';

Card simpleWorld(BuildContext context, VRChatLimitedWorld world) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
              ));
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 100.0,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 100.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Card simpleWorldFavorite(BuildContext context, VRChatFavoriteWorld world) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
              ));
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 100.0,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 100.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () {
                  getLoginSession("login_session").then(
                    (cookie) {
                      VRChatAPI(cookie: cookie ?? "").deleteFavorites(world.favoriteId).then((response) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const VRChatMobileWorldsFavorite(),
                            ));
                      }).catchError((status) {
                        apiError(context, status);
                      });
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Card simpleWorldPlus(BuildContext context, VRChatWorld world, VRChatInstance instance) {
  // instance is VRCinstance class
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
              ));
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 100.0,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 100.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: region(
                          instance.region,
                        ),
                      ),
                      const Icon(Icons.groups),
                      Padding(padding: const EdgeInsets.only(right: 5), child: Text("${instance.nUsers}/${instance.capacity}")),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(getVrchatInstanceType()[instance.type] ?? "?"),
                        ),
                      )
                    ]),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Card privatesimpleWorld(BuildContext context) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: CachedNetworkImage(
                imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 100.0,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 100.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    const SizedBox(width: double.infinity, child: Text("Private")),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.privateWorld,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Column world(BuildContext context, VRChatWorld world) {
  return Column(children: <Widget>[
    SizedBox(
      height: 250,
      child: CachedNetworkImage(
        imageUrl: world.imageUrl,
        fit: BoxFit.fitWidth,
        progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
          width: 250.0,
          child: CircularProgressIndicator(),
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
  ]);
}

Widget worldAction(BuildContext context, String wid, List<Widget> bottomSheet) {
  return IconButton(
    icon: const Icon(Icons.favorite),
    onPressed: () => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(children: bottomSheet),
      ),
    ),
  );
}
