// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/enum/region.dart';

class RegionWidget extends ConsumerWidget {
  final VRChatRegion region;
  final double size;
  const RegionWidget({required this.region, this.size = 15, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: size,
      height: size,
      child: CachedNetworkImage(
        imageUrl: region.toUri().toString(),
        fit: BoxFit.fitWidth,
        progressIndicatorBuilder: (context, url, downloadProgress) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
