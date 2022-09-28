// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/assets/vrchat/status.dart';

Container status(String status, {double diameter = 20}) {
  return Container(
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color(getVrchatStatus()[status] ?? 0xFFFFFFFF),
    ),
  );
}
