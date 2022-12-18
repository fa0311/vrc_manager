// Flutter imports:

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';

Future delete({
  required VRChatAPI vrchatLoginSession,
  required VRChatFavoriteWorld world,
  required List<VRChatFavoriteWorld> favoriteWorld,
}) async {
  await vrchatLoginSession.deleteFavorites(world.favoriteId);
  favoriteWorld.remove(world);
}
