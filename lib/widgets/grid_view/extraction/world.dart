// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';

GridView extractionWorldDefault(
  BuildContext context,
  GridConfig config,
  List<VRChatLimitedWorld> worldList,
) {
  return renderGrid(
    context,
    width: 600,
    height: 130,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return genericTemplate(
            context,
            imageUrl: world.thumbnailImageUrl,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
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

GridView extractionWorldSimple(
  BuildContext context,
  GridConfig config,
  List<VRChatLimitedWorld> worldList,
) {
  return renderGrid(
    context,
    width: 320,
    height: 64,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return genericTemplate(
            context,
            imageUrl: world.thumbnailImageUrl,
            half: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
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

GridView extractionWorldText(
  BuildContext context,
  GridConfig config,
  List<VRChatLimitedWorld> worldList,
) {
  return renderGrid(
    context,
    width: 400,
    height: config.worldDetails ? 39 : 26,
    children: [
      for (VRChatLimitedWorld world in worldList)
        () {
          return genericTemplateText(
            context,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                )),
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
