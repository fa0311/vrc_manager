// Flutter imports:

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';

Future delete({
  required VRChatAPI vrchatLoginSession,
  required VRChatFavoriteWorld world,
  required List<VRChatFavoriteWorld> favoriteWorld,
}) async {
  await vrchatLoginSession.deleteFavorites(world.favoriteId).catchError((e) {
    logger.e(e);
  });
  favoriteWorld.remove(world);
}
