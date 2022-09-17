// Dart imports:
import 'package:vrchat_mobile_client/assets/storage.dart';

class AppConfig {
  AccountConfig? loggedAccount;
  late List<AccountConfig> accountList = [];

  Future get() async {
    List<Future> futureList = [];
    List<Future> futureListLogin = [];
    List uidList = [];
    late String? accountUid;

    futureList.add(getStorage("account_index").then((value) => accountUid = value));
    futureList.add(getStorageList("account_index_list").then((List<String> value) => uidList = value));

    await Future.wait(futureList).then((value) {
      for (String uid in uidList) {
        AccountConfig accountConfig = AccountConfig(uid);
        futureListLogin.add(getLoginSession("cookie", uid).then((value) => accountConfig.cookie = value ?? ""));
        futureListLogin.add(getLoginSession("userid", uid).then((value) => accountConfig.userid = value ?? ""));
        futureListLogin.add(getLoginSession("password", uid).then((value) => accountConfig.password = value ?? ""));
        futureListLogin.add(getLoginSession("displayname", uid).then((value) => accountConfig.displayname = value ?? ""));
        futureListLogin.add(getLoginSession("remember_login_info", uid).then((value) => accountConfig.rememberLoginInfo = (value == "true")));
        accountList.add(accountConfig);
        if (uid == accountUid) {
          loggedAccount = accountConfig;
        }
      }
    });
    return Future.wait(futureListLogin);
  }

  Future removeAccount(AccountConfig account) async {
    List<Future> futureList = [];

    futureList.add(removeLoginSession("userid", account.uid));
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

  Future<bool> login(AccountConfig accountConfig) async {
    loggedAccount = accountConfig;
    return await setStorage("account_index", accountConfig.uid);
  }

  bool isLogined() {
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

class AccountConfig {
  final String uid;
  String cookie = "";
  String? userid;
  String? password;
  String? displayname;
  bool rememberLoginInfo = false;
  AccountConfig(this.uid);

  Future setCookie(String value) async {
    return await setLoginSession("cookie", cookie = value, uid);
  }

  Future setUserId(String value) async {
    return await setLoginSession("userid", userid = value, uid);
  }

  Future setPassword(String value) async {
    await setLoginSession("password", password = value, uid);
  }

  Future setDisplayName(String value) async {
    return await setLoginSession("displayname", displayname = value, uid);
  }

  Future setRememberLoginInfo(bool value) async {
    return await setLoginSession("remember_login_info", (rememberLoginInfo = value) ? "true" : "false", uid);
  }

  Future removeCookie() async {
    cookie = "";
    return await removeLoginSession("cookie", uid);
  }

  Future removeUserId() async {
    userid = null;
    return await removeLoginSession("userid", uid);
  }

  Future removePassword() async {
    password = null;
    return await removeLoginSession("password", uid);
  }

  Future removeDisplayName() async {
    displayname = null;
    return await removeLoginSession("displayname", uid);
  }
}

class GridConfig {
  late String key;
  late bool friendsAutoReadMore;
  late String friendsSort;
  late String friendsDisplayMode;
  late bool friendsDescending;

  GridConfig(this.key);

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(getStorage("auto_read_more").then((String? value) => friendsAutoReadMore = (value == "true")));
    futureList.add(getStorage("friends_sort").then((String? value) => friendsSort = (value ?? "default")));
    futureList.add(getStorage("friends_display_mode").then((String? value) => friendsDisplayMode = (value ?? "default")));
    futureList.add(getStorage("friends_descending").then((String? value) => friendsDescending = (value == "true")));
    return Future.wait(futureList);
  }
}
