import 'package:flutter/widgets.dart';
import 'package:vrchat_mobile_client/assets/vrchat/region.dart';

region(String region) {
  return SizedBox(width: 15, height: 15, child: Image.network(getVrchatRegion()[region] ?? "https://assets.vrchat.com/www/images/Region_US.png"));
}
