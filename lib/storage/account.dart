// Flutter imports:
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';

class AccountListConfigNotifier extends ChangeNotifier {
  List<AccountConfig> accountList = [];
  bool isFirst = true;

  init() async {
    isFirst = false;

    List<String> uidList = await getStorageList("account_index_list");
    List<Future> futureList = [];
    for (String uid in uidList) {
      AccountConfig accountConfig = AccountConfig(uid);
      accountList.add(accountConfig);
      futureList.add(accountConfig.init());
    }
    await Future.wait(futureList);
  }

  Future addAccount(AccountConfig accountConfig) async {
    if (accountList.contains(accountConfig)) return;
    accountList.add(accountConfig);
    notifyListeners();
    await setStorageList("account_index_list", getAccountList());
  }

  Future removeAccount(AccountConfig account) async {
    accountList.remove(account);
    notifyListeners();

    return Future.wait([
      account.removeUserId(),
      account.removeRememberLoginInfo(),
      account.removeCookie(),
      account.removePassword(),
      account.removeDisplayName(),
      setStorageList("account_index_list", getAccountList()),
    ]);
  }

  Future<AccountConfig?> getLoggedAccount() async {
    return getAccount(await getStorage("account_index") ?? "");
  }

  List<String> getAccountList() {
    return [for (AccountConfig account in accountList) account.uid];
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

class AccountConfigNotifier extends ChangeNotifier {
  AccountConfig? loggedAccount;
  String userAgent = "";

  init(AccountConfig? account) async {
    loggedAccount = account;
    await PackageInfo.fromPlatform().then((value) => userAgent = Assets.userAgent(value.version));
  }

  Future<bool> logout() async {
    loggedAccount = null;
    notifyListeners();
    return await removeStorage("account_index");
  }

  Future login(AccountConfig value) async {
    loggedAccount = value;
    notifyListeners();
    await setStorage("account_index", value.uid);
  }

  bool isLogout() {
    return loggedAccount == null || loggedAccount!.cookie == null;
  }
}

class AccountConfig extends ChangeNotifier {
  final String uid;
  String? cookie;
  String? userId;
  String? password;
  String? displayName;
  bool rememberLoginInfo = false;
  VRChatUserSelfOverload? data;

  AccountConfig(this.uid);

  Future init() async {
    await Future.wait([
      getLoginSession("cookie", uid).then((value) => cookie = value ?? ""),
      getLoginSession("user_id", uid).then((value) => userId = value),
      getLoginSession("password", uid).then((value) => password = value),
      getLoginSession("display_name", uid).then((value) => displayName = value),
      getLoginSession("remember_login_info", uid).then((value) => rememberLoginInfo = (value == "true")),
    ]);
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

  Future removeRememberLoginInfo() async {
    rememberLoginInfo = false;
    return await removeLoginSession("remember_login_info", uid);
  }

  Future<bool> tokenCheck() async {
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: cookie ?? "",
      userAgent: Assets.userAgent((await PackageInfo.fromPlatform()).version),
      logger: logger,
    );
    return await vrchatLoginSession.user().then((VRChatUserSelfOverload response) {
      data = response;
      setDisplayName(response.displayName);
      return true;
    }).catchError((e, trace) {
      logger.e(getMessage(e), e, trace);
      data = null;
      return false;
    });
  }
}
