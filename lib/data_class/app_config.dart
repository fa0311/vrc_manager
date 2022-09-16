import 'package:vrchat_mobile_client/assets/storage.dart';

class AppConfig {
  late String? accountUid;
  late List<String> uidList;
  late List<AccountConfig> accountList = [];

  Future get() async {
    List<Future> futureList = [];
    List<Future> futureListLogin = [];

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
      }
    });
    return Future.wait(futureListLogin);
  }

  Future removeAccount(String uid) async {
    List<Future> futureList = [];
    for (AccountConfig account in accountList) {
      if (account.uid == uid) {
        futureList.add(removeLoginSession("userid", uid));
        futureList.add(removeLoginSession("remember_login_info", uid));
        futureList.add(account.removeCookie());
        futureList.add(account.removePassword());
        futureList.add(account.removeDisplayName());
        uidList.remove(uid);
        accountList.remove(account);
      }
    }
    futureList.add(setStorageList("account_index_list", uidList));
    return Future.wait(futureList);
  }

  void addAccount() {}

  AccountConfig? getLoggedAccount() {
    for (AccountConfig account in accountList) {
      if (account.uid == accountUid) {
        return account;
      }
    }
    return null;
  }
}

class AccountConfig {
  String uid;
  String cookie;
  String? userid;
  String? password;
  String? displayname;
  bool rememberLoginInfo = false;
  AccountConfig(this.uid, {this.cookie = ""});

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
    return await setLoginSession("displayname", userid = value, uid);
  }

  Future setRememberLoginInfo(bool value) async {
    return await setLoginSession("remember_login_info", (rememberLoginInfo = value) ? "true" : "false", uid);
  }

  Future removeCookie() async {
    cookie = "";
    return await removeLoginSession("cookie", uid);
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

class ListConfig {
  late String key;
  late bool friendsAutoReadMore;
  late String friendsSort;
  late String friendsDisplayMode;
  late bool friendsDescending;

  ListConfig(this.key);

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(getStorage("auto_read_more").then((String? value) => friendsAutoReadMore = (value == "true")));
    futureList.add(getStorage("friends_sort").then((String? value) => friendsSort = (value ?? "default")));
    futureList.add(getStorage("friends_display_mode").then((String? value) => friendsDisplayMode = (value ?? "default")));
    futureList.add(getStorage("friends_descending").then((String? value) => friendsDescending = (value == "true")));
    return Future.wait(futureList);
  }
}
