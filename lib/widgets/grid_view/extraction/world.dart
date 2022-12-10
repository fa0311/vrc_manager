// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/storage/grid_config.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/world.dart';

Widget extractionWorldDefault(
  BuildContext context,
  GridConfigNotifier config,
  List<VRChatLimitedWorld> worldList,
) {
  return RenderGrid(
    width: 600,
    height: 130,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return GenericTemplate(
            imageUrl: world.thumbnailImageUrl,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
            onLongPress: () => modalBottom(context, [favoriteListTileWidget(context, world)]),
            children: [
              SizedBox(
                child: Text(
                  world.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1,
                  ),
                ),
              ),
            ],
          );
        }(),
    ],
  );
}

Widget extractionWorldSimple(
  BuildContext context,
  GridConfigNotifier config,
  List<VRChatLimitedWorld> worldList,
) {
  return RenderGrid(
    width: 320,
    height: 64,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return GenericTemplate(
            imageUrl: world.thumbnailImageUrl,
            half: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
            onLongPress: () => modalBottom(context, [favoriteListTileWidget(context, world)]),
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  world.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ),
            ],
          );
        }(),
    ],
  );
}

Widget extractionWorldText(
  BuildContext context,
  GridConfigNotifier config,
  List<VRChatLimitedWorld> worldList,
) {
  return RenderGrid(
    width: 400,
    height: config.worldDetails ? 39 : 26,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return GenericTemplateText(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
            onLongPress: () => modalBottom(context, [favoriteListTileWidget(context, world)]),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(world.name, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ],
          );
        }(),
    ].whereType<Widget>().toList(),
  );
}
