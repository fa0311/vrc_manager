// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/share.dart';

void urlParser(BuildContext context, Uri url) {
  final List<String> path = url.path.split("/");
  final Map<String, String> queryParameters = url.queryParameters;
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
  } else {
    openInBrowser(context, url);
  }
}
