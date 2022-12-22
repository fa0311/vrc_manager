// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/share.dart';

Future<Widget?> urlParser({required Uri url, required bool forceExternal}) async {
  final List<String> path = url.path.split("/");
  final Map<String, String> queryParameters = url.queryParameters;
  if (path.length < 2) {
    return null;
  } else if (path[2] == "launch") {
    return VRChatMobileSplash(child: VRChatMobileWorld(worldId: queryParameters["worldId"] ?? ""));
  } else if (path[2] == "world") {
    return VRChatMobileSplash(child: VRChatMobileWorld(worldId: path[3]));
  } else if (path[2] == "user") {
    return VRChatMobileSplash(child: VRChatMobileUser(userId: path[3]));
  } else {
    return await openInBrowser(url: url, forceExternal: forceExternal);
  }
}
