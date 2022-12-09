// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/api/post.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/storage/grid_config.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/world.dart';

Widget extractionWorldDefault(
  BuildContext context,
  GridConfigNotifier config,
  List<VRChatFavoriteWorld> favoriteWorld,
) {
  return StatefulBuilder(
    builder: (BuildContext context, setState) => renderGrid(
      context,
      width: 600,
      height: 130,
      children: [
        for (VRChatFavoriteWorld world in favoriteWorld)
          () {
            return genericTemplate(
              context,
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
              right: config.removeButton
                  ? [
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          onPressed: () => delete(context, world, favoriteWorld).then((value) => setState(() {})),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ]
                  : null,
            );
          }(),
      ],
    ),
  );
}

Widget extractionWorldSimple(
  BuildContext context,
  GridConfigNotifier config,
  List<VRChatFavoriteWorld> favoriteWorld,
) {
  return StatefulBuilder(
    builder: (BuildContext context, _) => renderGrid(
      context,
      width: 320,
      height: 64,
      children: [
        for (VRChatFavoriteWorld world in favoriteWorld)
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
              stack: config.removeButton
                  ? [
                      SizedBox(
                        height: 17,
                        width: 17,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 15,
                        color: Colors.white,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(0),
                        onPressed: () => delete(context, world, favoriteWorld),
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  : null,
            );
          }(),
      ],
    ),
  );
}
