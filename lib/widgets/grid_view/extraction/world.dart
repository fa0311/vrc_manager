// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/sort/worlds.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/consumer.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/world.dart';

class ExtractionWorld extends ConsumerGridWidget {
  final List<VRChatLimitedWorld> worldList;
  final ScrollPhysics? physics;

  const ExtractionWorld({super.key, required super.id, required this.worldList, this.physics});

  @override
  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    List<VRChatLimitedWorld> sortedWorldList = sortWorlds(config, worldList);

    return RenderGrid(
      width: 600,
      height: 130,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: sortedWorldList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatLimitedWorld world = sortedWorldList[index];
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
      },
    );
  }

  @override
  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    List<VRChatLimitedWorld> sortedWorldList = sortWorlds(config, worldList);

    return RenderGrid(
      width: 320,
      height: 64,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: sortedWorldList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatLimitedWorld world = sortedWorldList[index];
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
      },
    );
  }

  @override
  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    List<VRChatLimitedWorld> sortedWorldList = sortWorlds(config, worldList);

    return RenderGrid(
      width: 400,
      height: config.worldDetails ? 39 : 26,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: sortedWorldList.length,
      itemBuilder: (BuildContext context, int index) {
        VRChatLimitedWorld world = sortedWorldList[index];
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
                Text(world.name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        );
      },
    );
  }
}
