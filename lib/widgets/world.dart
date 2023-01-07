// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/date.dart';

class OnTheWebsite extends ConsumerWidget {
  final bool half;
  const OnTheWebsite({super.key, this.half = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      height: half ? 50 : 100,
      child: Text(AppLocalizations.of(context)!.onTheWebsite, style: TextStyle(fontSize: half ? 10 : 15)),
    );
  }
}

class WorldProfile extends ConsumerWidget {
  final VRChatWorld world;
  const WorldProfile({super.key, required this.world});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 250,
          child: CachedNetworkImage(
            imageUrl: world.imageUrl,
            fit: BoxFit.fitWidth,
            progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
              width: 250.0,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const SizedBox(
              width: 250.0,
              child: Icon(Icons.error),
            ),
          ),
        ),
        Text(world.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(child: Text(world.description ?? "")),
        ),
        Text(
          AppLocalizations.of(context)!.occupants(world.occupants),
        ),
        Text(
          AppLocalizations.of(context)!.privateOccupants(world.privateOccupants),
        ),
        Text(
          AppLocalizations.of(context)!.favorites(world.favorites),
        ),
        Text(
          AppLocalizations.of(context)!.createdAt(
            generalDateDifference(context, world.createdAt),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.updatedAt(
            generalDateDifference(context, world.updatedAt),
          ),
        ),
      ],
    );
  }
}
