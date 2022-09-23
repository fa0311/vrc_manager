// Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';

GridView renderGrid(
  BuildContext context, {
  required int width,
  required int height,
  required List<Widget> children,
}) {
  double screenSize = MediaQuery.of(context).size.width;

  return GridView.count(
    crossAxisCount: screenSize ~/ width + 1,
    crossAxisSpacing: 0,
    mainAxisSpacing: 0,
    childAspectRatio: screenSize / (screenSize ~/ width + 1) / height,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: children,
  );
}

Widget genericTemplate(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  required String imageUrl,
  void Function()? onTap,
  Widget? bottom,
  List<Widget>? stack,
  bool card = true,
  bool half = false,
}) {
  Widget content = GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(
      children: [
        Row(
          children: <Widget>[
            SizedBox(
              height: half ? 50 : 100,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                  width: half ? 50 : 100,
                  child: const Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  width: half ? 50 : 100,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: half ? 10 : 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            ),
          ],
        ),
        if (bottom != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: bottom,
          ),
      ],
    ),
  );
  if (card && stack != null) {
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.all(half ? 2 : 5),
      child: Stack(
        children: <Widget>[
          Container(padding: EdgeInsets.all(half ? 5 : 10), child: content),
          ...stack,
        ],
      ),
    );
  } else if (card) {
    return Card(
      elevation: 20.0,
      margin: EdgeInsets.all(half ? 2 : 5),
      child: Container(
        padding: EdgeInsets.all(half ? 5 : 10),
        child: content,
      ),
    );
  } else {
    return content;
  }
}

Widget instanceWidget(
  BuildContext context,
  AppConfig appConfig,
  VRChatWorld world,
  VRChatInstance instance, {
  bool card = false,
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
      SizedBox(
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
      SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.privateWorld,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: half ? 10 : 15,
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
      SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.privateWorld,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: half ? 10 : 15,
          ),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/normalbetween_image.png",
  );
}

Widget genericTemplateText(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  void Function()? onTap,
}) {
  return Card(
    margin: const EdgeInsets.all(2),
    elevation: 20.0,
    child: GestureDetector(
      onTap: () => onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
}
/*
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
      }),
      */

sort(GridConfig config, List<VRChatUser> userList) {
  if (config.sort == "name") {
    sortByName(userList);
  } else if (config.sort == "last_login") {
    sortByLastLogin(userList);
  } else if (config.sort == "friends_in_instance") {
    sortByLocationMap(userList);
  }
}

class LocationDataClass {
  int id;
  int count = 0;
  LocationDataClass(this.id);
}

Map<String, LocationDataClass> numberOfFriendsInLocation(List<VRChatUser> userList) {
  Map<String, LocationDataClass> inLocation = {};
  int id = 0;
  for (VRChatUser user in userList) {
    String location = user.location;
    inLocation[location] ??= LocationDataClass(++id);
    inLocation[location]!.count++;
  }
  return inLocation;
}

sortByLocationMap(List<VRChatUser> userList) {
  Map<String, LocationDataClass> inLocation = numberOfFriendsInLocation(userList);
  userList.sort((userA, userB) {
    String locationA = userA.location;
    String locationB = userB.location;
    if (locationA == locationB) return 0;
    if (locationA == "offline") return 1;
    if (locationB == "offline") return -1;
    if (locationA == "private") return 1;
    if (locationB == "private") return -1;
    if (locationA == "traveling") return 1;
    if (locationB == "traveling") return -1;
    if (inLocation[locationA]!.count > inLocation[locationB]!.count) return -1;
    if (inLocation[locationA]!.count < inLocation[locationB]!.count) return 1;
    if (inLocation[locationA]!.id > inLocation[locationB]!.id) return -1;
    if (inLocation[locationA]!.id < inLocation[locationB]!.id) return 1;
    return 0;
  });
}

sortByName(List<VRChatUser> userList) {
  userList.sort((userA, userB) {
    List<int> userBytesA = utf8.encode(userA.displayName);
    List<int> userBytesB = utf8.encode(userB.displayName);
    for (int i = 0; i < userBytesA.length && i < userBytesB.length; i++) {
      if (userBytesA[i] < userBytesB[i]) return -1;
      if (userBytesA[i] > userBytesB[i]) return 1;
    }
    if (userBytesA.length < userBytesB.length) return -1;
    if (userBytesA.length > userBytesB.length) return 1;
    return 0;
  });
}

sortByLastLogin(List<VRChatUser> userList) {
  userList.sort((userA, userB) {
    if (userA.lastLogin == null) return 1;
    if (userB.lastLogin == null) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch > userB.lastLogin!.millisecondsSinceEpoch) return -1;
    if (userA.lastLogin!.millisecondsSinceEpoch < userB.lastLogin!.millisecondsSinceEpoch) return 1;
    return 0;
  });
}
