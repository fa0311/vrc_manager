import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/assets/storage.dart';

final userPolicyConfigProvider = ChangeNotifierProvider<UserPolicyConfigNotifier>((ref) => UserPolicyConfigNotifier());

class UserPolicyConfigNotifier extends ChangeNotifier {
  bool agree = true;

  UserPolicyConfigNotifier() {
    Future.wait([
      getStorage("agreed_user_policy").then((String? value) => agree = (value == "true")),
    ]).then((_) => notifyListeners());
  }

  Future setAgree(bool value) async {
    agree = value;
    notifyListeners();
    return await setStorage("agreed_user_policy", agree ? "true" : "false");
  }
}
