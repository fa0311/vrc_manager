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

  const ExtractionWorld({
    super.key,
    required super.id,
    required this.worldList,
  });

  @override
  List<Widget> normal(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    return [
      for (VRChatLimitedWorld world in sortWorlds(config, worldList))
        () {
          return GenericTemplate(
            imageUrl: world.thumbnailImageUrl,
            onTap: world.id == "???"
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                      ),
                    ),
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
                  style: style.title,
                ),
              ),
            ],
          );
        }(),
    ];
  }

  @override
  List<Widget> simple(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    return [
      for (VRChatLimitedWorld world in sortWorlds(config, worldList))
        () {
          return GenericTemplate(
            imageUrl: world.thumbnailImageUrl,
            half: true,
            onTap: world.id == "???"
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
                      ),
                    ),
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
                  style: style.title,
                ),
              ),
            ],
          );
        }(),
    ];
  }

  @override
  List<Widget> textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config, ConsumerGridStyle style) {
    return [
      for (VRChatLimitedWorld world in sortWorlds(config, worldList))
        () {
          return GenericTemplateText(
            onTap: world.id == "???"
                ? null
                : () => Navigator.push(
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
                  Text(world.name, style: style.title),
                ],
              ),
            ],
          );
        }(),
    ];
  }
}
