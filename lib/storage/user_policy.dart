// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';

final userPolicyConfigProvider = ChangeNotifierProvider<UserPolicyConfigNotifier>((ref) => UserPolicyConfigNotifier());

class UserPolicyConfigNotifier extends ChangeNotifier {
  bool agree = true;
  bool isFirst = true;

  Future init() async {
    isFirst = false;
    await getStorage("agreed_user_policy").then((String? value) => agree = (value == "true"));
  }

  Future setAgree(bool value) async {
    agree = value;
    notifyListeners();
    return await setStorage("agreed_user_policy", agree ? "true" : "false");
  }
}
