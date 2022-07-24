// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';

void urlParser(BuildContext context, String strUri) {
  final List<String> path = Uri.parse(strUri).path.split("/");
  final Map<String, String> queryParameters = Uri.parse(strUri).queryParameters;
  if (path.length < 2) {
    return;
  } else if (path[2] == "launch") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWorld(worldId: queryParameters["worldId"] ?? ""),
      ),
      (_) => false,
    );
  } else if (path[2] == "world") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWorld(worldId: path[3]),
      ),
      (_) => false,
    );
  } else if (path[2] == "user") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileUser(userId: path[3]),
      ),
      (_) => false,
    );
  }
}
