// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';

class VRChatUserNotifier extends ChangeNotifier {
  VRChatUser? user;
  set(VRChatUser value) {
    user = value;
    notifyListeners();
  }
}

final vrchatUserNotifier = ChangeNotifierProvider<VRChatUserNotifier>((_) => VRChatUserNotifier());
