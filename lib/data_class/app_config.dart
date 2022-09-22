// Dart imports:
import 'package:vrchat_mobile_client/assets/storage.dart';

class AppConfig {
  AccountConfig? loggedAccount;
  List<AccountConfig> accountList = [];
  GridConfigList gridConfigList = GridConfigList();

  Future get() async {
    List<Future> futureList = [];
    List<Future> futureListLogin = [];
    List uidList = [];
    String? accountUid;

    futureList.add(getStorage("account_index").then((value) => accountUid = value));
    futureList.add(getStorageList("account_index_list").then((List<String> value) => uidList = value));
    futureList.add(gridConfigList.setConfig());

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

class GridConfigList {
  GridConfig onlineFriends = GridConfig("online_friends_config");
  GridConfig offlineFriends = GridConfig("offline_friends_config");
  GridConfig friendsRequest = GridConfig("friends_request_config");
  GridConfig searcUsers = GridConfig("search_users_config");
  GridConfig searcWorlds = GridConfig("search_worlds_config");
  GridConfig favoriteWorlds = GridConfig("favorite_worlds_config");

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(onlineFriends.setConfig());
    futureList.add(offlineFriends.setConfig());
    futureList.add(friendsRequest.setConfig());
    futureList.add(searcUsers.setConfig());
    futureList.add(searcWorlds.setConfig());
    futureList.add(favoriteWorlds.setConfig());
    return Future.wait(futureList);
  }
}

class GridConfig {
  late String id;
  late String sort;
  late String displayMode;
  late bool descending;
  late bool joinable;
  late bool worldDetails;

  GridConfig(this.id);

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(getStorage("sort", id: id).then((String? value) => sort = (value ?? "normal")));
    futureList.add(getStorage("display_mode", id: id).then((String? value) => displayMode = (value ?? "normal")));
    futureList.add(getStorage("descending", id: id).then((String? value) => descending = (value == "true")));
    futureList.add(getStorage("joinable", id: id).then((String? value) => joinable = (value == "true")));
    futureList.add(getStorage("world_details", id: id).then((String? value) => worldDetails = (value == "true")));

    return Future.wait(futureList);
  }

  Future setSort(String value) async {
    return await setStorage("sort", sort = value, id: sort);
  }

  Future setDisplayMode(String value) async {
    return await setStorage("display_mode", displayMode = value, id: id);
  }

  Future setDescending(bool value) async {
    return await setStorage("descending", (descending = value) ? "true" : "false", id: id);
  }

  Future setJoinable(bool value) async {
    return await setStorage("joinable", (joinable = value) ? "true" : "false", id: id);
  }

  Future setWorldDetails(bool value) async {
    return await setStorage("world_details", (worldDetails = value) ? "true" : "false", id: id);
  }
}
