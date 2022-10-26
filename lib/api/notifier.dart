import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/data_class.dart';

class VRChatUserNotifier extends StateNotifier<VRChatUser?> {
  VRChatUserNotifier() : super(null);
  set(VRChatUser user) {
    state = user;
  }
}

final vrchatUserNotifier = StateNotifierProvider<VRChatUserNotifier, VRChatUser?>((_) => VRChatUserNotifier());
