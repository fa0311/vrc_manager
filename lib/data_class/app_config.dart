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

  void removeAccount(String uid) {
    for (AccountConfig account in accountList) {
      if (account.uid == uid) {
        removeLoginSession("userid", uid);
        removeLoginSession("remember_login_info", uid);
        account
          ..removeCookie()
          ..removePassword()
          ..removeDisplayName();
        uidList.remove(uid);
        accountList.remove(account);
      }
    }
    setStorageList("account_index_list", uidList);
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

  setCookie(String value) {
    setLoginSession("cookie", cookie = value, uid);
  }

  setUserId(String value) {
    setLoginSession("userid", userid = value, uid);
  }

  setPassword(String value) {
    setLoginSession("password", password = value, uid);
  }

  setDisplayName(String value) {
    setLoginSession("displayname", userid = value, uid);
  }

  setRememberLoginInfo(bool value) {
    setLoginSession("remember_login_info", (rememberLoginInfo = value) ? "true" : "false", uid);
  }

  removeCookie() {
    cookie = "";
    removeLoginSession("cookie", uid);
  }

  removePassword() {
    password = null;
    removeLoginSession("password", uid);
  }

  removeDisplayName() {
    displayname = null;
    removeLoginSession("displayname", uid);
  }
}
