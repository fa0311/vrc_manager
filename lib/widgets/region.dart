// Flutter imports:
// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/assets/region.dart';
import 'package:vrc_manager/scenes/core/splash.dart';

class RegionWidget extends ConsumerWidget {
  final VRChatRegion region;
  final double size;
  const RegionWidget({required this.region, this.size = 15, super.key});

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
        httpHeaders: {
          "user-agent": ref.watch(accountConfigProvider).userAgent,
        },
      ),
    );
  }
}
