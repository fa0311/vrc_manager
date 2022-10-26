import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/data_class.dart';

class VRChatUserNotifier extends ChangeNotifier {
  VRChatUser? user;
  set(VRChatUser value) {
    user = value;
    notifyListeners();
  }
}

final vrchatUserNotifier = ChangeNotifierProvider<VRChatUserNotifier>((_) => VRChatUserNotifier());
