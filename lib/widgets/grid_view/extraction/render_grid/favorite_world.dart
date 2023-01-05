// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/post.dart';
import 'package:vrc_manager/assets/sort/worlds.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/consumer.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/world.dart';

class ExtractionFavoriteWorld extends ConsumerGridWidget {
  final List<VRChatFavoriteWorld> favoriteWorld;
  final ScrollPhysics? physics;

  const ExtractionFavoriteWorld({
    super.key,
    required super.id,
    required this.favoriteWorld,
    this.physics,
  });

  @override
  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "", logger: logger);

    return RenderGrid(
      width: 600,
      height: 130,
      children: [
        for (VRChatFavoriteWorld world in sortWorlds(config, favoriteWorld) as List<VRChatFavoriteWorld>)
          () {
            return GenericTemplate(
              imageUrl: world.thumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => WorldDetailsModalBottom(world: world),
                );
              },
              right: config.removeButton
                  ? [
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(0),
                          onPressed: () => delete(vrchatLoginSession: vrchatLoginSession, world: world, favoriteWorld: favoriteWorld),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ]
                  : null,
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

  @override
  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "", logger: logger);
    return RenderGrid(
      width: 320,
      height: 64,
      children: [
        for (VRChatFavoriteWorld world in sortWorlds(config, favoriteWorld) as List<VRChatFavoriteWorld>)
          () {
            return GenericTemplate(
              imageUrl: world.thumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => WorldDetailsModalBottom(world: world),
                );
              },
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
                        onPressed: () => delete(vrchatLoginSession: vrchatLoginSession, world: world, favoriteWorld: favoriteWorld),
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  : null,
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

  @override
  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatFavoriteWorld world in sortWorlds(config, favoriteWorld) as List<VRChatFavoriteWorld>)
          () {
            return GenericTemplateText(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () => WorldDetailsModalBottom(world: world),
                );
              },
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      world.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }(),
      ],
    );
  }
}
