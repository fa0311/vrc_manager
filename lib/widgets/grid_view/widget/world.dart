// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/vrchat/instance_type.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/region.dart';
import 'package:vrc_manager/widgets/world.dart';

Widget instanceWidget(
  BuildContext context,
  VRChatWorld world,
  VRChatInstance instance, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    imageUrl: world.thumbnailImageUrl,
    card: card,
    half: half,
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
        )),
    onLongPress: () => showWorldLongPressModal(context, instance),
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
  BuildContext context, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
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
  BuildContext context, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
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
