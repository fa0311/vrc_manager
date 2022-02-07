import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/vrchat/status.dart';

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
