// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/vrchat/region.dart';

SizedBox region(String region) {
  return SizedBox(
    width: 15,
    height: 15,
    child: CachedNetworkImage(
      imageUrl: getVrchatRegion()[region] ?? "https://assets.vrchat.com/www/images/Region_US.png",
      fit: BoxFit.fitWidth,
      progressIndicatorBuilder: (context, url, downloadProgress) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    ),
  );
}
