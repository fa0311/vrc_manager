import 'package:flutter/material.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/main.dart';

Future delete(BuildContext context, VRChatFavoriteWorld world, List<VRChatFavoriteWorld> favoriteWorld) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  await vrchatLoginSession.deleteFavorites(world.favoriteId).catchError((status) {
    apiError(context, status);
  });
  favoriteWorld.remove(world);
}
