// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
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