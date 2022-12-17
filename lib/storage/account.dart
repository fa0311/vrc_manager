// Flutter imports:
import 'package:flutter/material.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';

// Project imports:
import 'package:vrc_manager/assets/storage.dart';

class AccountConfigNotifier extends ChangeNotifier {
  AccountConfig? loggedAccount;
  List<AccountConfig> accountList = [];

  init() async {
    List uidList = [];
    String? accountUid;

    await Future.wait([
      getStorage("account_index").then((value) => accountUid = value),
      getStorageList("account_index_list").then((List<String> value) => uidList = value),
    ]);
    for (String uid in uidList) {
      AccountConfig accountConfig = AccountConfig(uid);
      accountList.add(accountConfig);
      if (uid == accountUid) {
        loggedAccount = accountConfig;
      }
    }
  }

  Future removeAccount(AccountConfig account) async {
    List<Future> futureList = [];

    futureList.add(removeLoginSession("user_id", account.uid));
    futureList.add(removeLoginSession("remember_login_info", account.uid));
    futureList.add(account.removeCookie());
    futureList.add(account.removePassword());
    futureList.add(account.removeDisplayName());
    accountList.remove(account);

    futureList.add(setStorageList("account_index_list", getAccountList()));

    if (loggedAccount == account) {
      if (accountList.isEmpty) {
        futureList.add(logout());
      } else {
        loggedAccount = accountList.first;
      }
    }
    return Future.wait(futureList);
  }

  Future<bool> logout() async {
    loggedAccount = null;
    return await removeStorage("account_index");
  }

  Future<bool> login(BuildContext context, AccountConfig accountConfig) async {
    List<Future> futureList = [];
    loggedAccount = accountConfig;
    if (!(await loggedAccount!.tokenCheck())) return false;
    futureList.add(setStorage("account_index", accountConfig.uid));
    await Future.wait(futureList);
    return true;
  }

  bool isLogout() {
    return loggedAccount != null;
  }

  List<String> getAccountList() {
    List<String> uidList = [];
    for (AccountConfig account in accountList) {
      uidList.add(account.uid);
    }
    return uidList;
  }

  Future addAccount(AccountConfig accountConfig) async {
    accountList.add(accountConfig);
    await setStorageList("account_index_list", getAccountList());
  }

  AccountConfig? getAccount(String uid) {
    for (AccountConfig account in accountList) {
      if (uid == account.uid) {
        return account;
      }
    }
    return null;
  }
}

class AccountConfig extends ChangeNotifier {
  final String uid;
  String cookie = "";
  String? userId;
  String? password;
  String? displayName;
  bool rememberLoginInfo = false;
  AccountConfig(this.uid);

  Future init() async {
    await Future.wait([
      getLoginSession("cookie", uid).then((value) => cookie = value ?? ""),
      getLoginSession("user_id", uid).then((value) => userId = value ?? ""),
      getLoginSession("password", uid).then((value) => password = value ?? ""),
      getLoginSession("display_name", uid).then((value) => displayName = value ?? ""),
      getLoginSession("remember_login_info", uid).then((value) => rememberLoginInfo = (value == "true"))
    ]);
    notifyListeners();
  }

  Future setCookie(String value) async {
    return await setLoginSession("cookie", cookie = value, uid);
  }

  Future setUserId(String value) async {
    return await setLoginSession("user_id", userId = value, uid);
  }

  Future setPassword(String value) async {
    await setLoginSession("password", password = value, uid);
  }

  Future setDisplayName(String value) async {
    return await setLoginSession("display_name", displayName = value, uid);
  }

  Future setRememberLoginInfo(bool value) async {
    return await setLoginSession("remember_login_info", (rememberLoginInfo = value).toString(), uid);
  }

  Future removeCookie() async {
    cookie = "";
    return await removeLoginSession("cookie", uid);
  }

  Future removeUserId() async {
    userId = null;
    return await removeLoginSession("user_id", uid);
  }

  Future removePassword() async {
    password = null;
    return await removeLoginSession("password", uid);
  }

  Future removeDisplayName() async {
    displayName = null;
    return await removeLoginSession("display_name", uid);
  }

  Future tokenCheck() async {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: cookie);
    VRChatUserSelfOverload response = await vrchatLoginSession.user();
    setDisplayName(response.displayName);
  }
}
