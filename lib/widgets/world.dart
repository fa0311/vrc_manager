// Flutter imports:

// Dart imports:

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
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/assets/vrchat/instance_type.dart';
import 'package:vrc_manager/scenes/world.dart';
import 'package:vrc_manager/widgets/region.dart';

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
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        overflow: TextOverflow.ellipsis,
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

Card simpleWorldDescription(BuildContext context, VRChatWorld world) {
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
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (world.description != null)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          world.description!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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

Card simpleWorldDescriptionHalf(BuildContext context, VRChatWorld world) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
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
              height: 50,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 50.0,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1,
                        ),
                      ),
                    ),
                    if (world.description != null)
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          world.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1,
                          ),
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

Card simpleWorldPlus(BuildContext context, VRChatWorld world, VRChatInstance instance) {
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
                          child: Text(
                            getVrchatInstanceType(context)[instance.type] ?? "Error",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if ((instance.shortName ?? instance.secureName) != null)
                      SizedBox(
                        height: 30,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.grey,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          ),
                          onPressed: () => getLoginSession("login_session").then(
                            (cookie) => VRChatAPI(cookie: cookie ?? "")
                                .selfInvite(instance.location, instance.shortName ?? "")
                                .then((VRChatNotificationsInvite response) {
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
                            }),
                          ),
                          child: Text(AppLocalizations.of(context)!.joinInstance),
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

Card simpleWorldHalf(BuildContext context, VRChatLimitedWorld world) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
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
              height: 50,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 50.0,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50.0,
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          height: 1,
                        ),
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

Card simpleWorldPlusHalf(BuildContext context, VRChatWorld world, VRChatInstance instance) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
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
              height: 50,
              child: CachedNetworkImage(
                imageUrl: world.thumbnailImageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 50.0,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50.0,
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
                          size: 10,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text("${instance.nUsers}/${instance.capacity}", style: const TextStyle(fontSize: 12))),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            getVrchatInstanceType(context)[instance.type] ?? "Error",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        world.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          height: 1,
                        ),
                      ),
                    ),
                    if ((instance.shortName ?? instance.secureName) != null)
                      SizedBox(
                        height: 16,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.grey,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          ),
                          onPressed: () => getLoginSession("login_session").then(
                            (cookie) => VRChatAPI(cookie: cookie ?? "")
                                .selfInvite(instance.location, instance.shortName ?? "")
                                .then((VRChatNotificationsInvite response) {
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
                            }),
                          ),
                          child: Text(AppLocalizations.of(context)!.joinInstance, style: const TextStyle(fontSize: 10)),
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

Card privateSimpleWorld(BuildContext context) {
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
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
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

Card privateSimpleWorldHalf(BuildContext context) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: CachedNetworkImage(
                imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 50.0,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Private",
                          style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.privateWorld,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          height: 1,
                        ),
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

Card travelingWorld(BuildContext context) {
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
                imageUrl: "https://assets.vrchat.com/www/images/default_between_image.png",
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 100.0,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
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
                    const SizedBox(width: double.infinity, child: Text("Traveling")),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.traveling,
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

Card travelingWorldHalf(BuildContext context) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: CachedNetworkImage(
                imageUrl: "https://assets.vrchat.com/www/images/default_between_image.png",
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                  width: 50.0,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox(
                  width: 50.0,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Traveling",
                          style: TextStyle(
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.traveling,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          height: 1,
                        ),
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
