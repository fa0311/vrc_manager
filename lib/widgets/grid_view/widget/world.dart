// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/world.dart';
import 'package:vrc_manager/widgets/region.dart';

class InstanceWidget extends ConsumerWidget {
  final VRChatWorld world;
  final VRChatInstance instance;
  final bool card;
  final bool half;

  const InstanceWidget({
    super.key,
    required this.world,
    required this.instance,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      imageUrl: world.thumbnailImageUrl,
      card: card,
      half: half,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
        ),
      ),
      onLongPress: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () => InstanceDetailsModalBottom(world: world, instance: instance),
        );
      },
      children: [
        Row(children: <Widget>[
          RegionWidget(region: instance.region, size: half ? 12 : 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(Icons.groups, size: half ? 17 : 25),
                Text(
                  "${instance.nUsers}/${instance.capacity}",
                  style: TextStyle(fontSize: half ? 10 : 15),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                instance.type.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: half ? 10 : 15,
                ),
              ),
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
}

class PrivateWorld extends ConsumerWidget {
  final bool card;
  final bool half;

  const PrivateWorld({
    super.key,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      card: card,
      half: half,
      imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Private",
            style: TextStyle(fontSize: half ? 10 : 15),
          ),
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
    );
  }
}

class TravelingWorld extends ConsumerWidget {
  final bool card;
  final bool half;

  const TravelingWorld({
    super.key,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      card: card,
      half: half,
      imageUrl: "https://assets.vrchat.com/www/images/normalbetween_image.png",
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "Traveling",
            style: TextStyle(fontSize: half ? 10 : 15),
          ),
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
    );
  }
}
