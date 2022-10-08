// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/user.dart';
import 'package:vrc_manager/scenes/world.dart';
import 'package:vrc_manager/widgets/share.dart';

void urlParser(BuildContext context, AppConfig appConfig, String strUri) {
  final List<String> path = Uri.parse(strUri).path.split("/");
  final Map<String, String> queryParameters = Uri.parse(strUri).queryParameters;
  if (path.length < 2) {
    return;
  } else if (path[2] == "launch") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: queryParameters["worldId"] ?? ""),
      ),
      (_) => false,
    );
  } else if (path[2] == "world") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: path[3]),
      ),
      (_) => false,
    );
  } else if (path[2] == "user") {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: path[3]),
      ),
      (_) => false,
    );
  } else {
    openInBrowser(context, appConfig, strUri);
  }
}
