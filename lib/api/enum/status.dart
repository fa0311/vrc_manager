import 'package:flutter/material.dart';

enum VRChatStatusData {
  active(text: "active", color: 0xFF51e57e),
  joinMe(text: "join me", color: 0xFF42CAFF),
  busy(text: "busy", color: 0xFF5b0b0b),
  askMe(text: "ask me", color: 0xFFe88134),
  offline(text: "offline", color: 0xFF808080);

  Color toColor() {
    return Color(color);
  }

  final String text;
  final int color;
  const VRChatStatusData({required this.text, required this.color});
}

VRChatStatusData byVrchatStatusData(Uri uri) {
  for (VRChatStatusData key in VRChatStatusData.values) {
    if (uri.host.contains(key.text)) return key;
  }
  return VRChatStatusData.offline;
}
