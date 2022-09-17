import 'package:vrchat_mobile_client/assets/storage.dart';

class AppConfig {
  late String? _accountUid;
  late Map<String, AccountConfig> accountList = {};
  late Map<String, GridConfig> listConfig = {};

  Future get() async {
    List<Future> futureList = [];
    List<Future> futureListLogin = [];
    List uidList = [];

    futureList.add(getStorage("account_index").then((value) => _accountUid = value));
    futureList.add(getStorageList("account_index_list").then((List<String> value) => uidList = value));

    await Future.wait(futureList).then((value) {
      for (String uid in uidList) {
        AccountConfig accountConfig = AccountConfig(uid);
        futureListLogin.add(getLoginSession("cookie", uid).then((value) => accountConfig.cookie = value ?? ""));
        futureListLogin.add(getLoginSession("userid", uid).then((value) => accountConfig.userid = value ?? ""));
        futureListLogin.add(getLoginSession("password", uid).then((value) => accountConfig.password = value ?? ""));
        futureListLogin.add(getLoginSession("displayname", uid).then((value) => accountConfig.displayname = value ?? ""));
        futureListLogin.add(getLoginSession("remember_login_info", uid).then((value) => accountConfig.rememberLoginInfo = (value == "true")));
        accountList[uid] = accountConfig;
      }
    });
    return Future.wait(futureListLogin);
  }

  Future removeAccount(String uid) async {
    List<Future> futureList = [];
    AccountConfig? account = accountList[uid];
    if (account == null) return Future;

    futureList.add(removeLoginSession("userid", uid));
    futureList.add(removeLoginSession("remember_login_info", uid));
    futureList.add(account.removeCookie());
    futureList.add(account.removePassword());
    futureList.add(account.removeDisplayName());
    accountList.remove(uid);

    futureList.add(setStorageList("account_index_list", getAccountList()));

    if (_accountUid == uid) {
      _accountUid = accountList.keys.first;
    }

    return Future.wait(futureList);
  }

  bool isLogined() {
    return _accountUid != null;
  }

  setAccount(String uid) {
    if (accountList.containsKey(uid)) {
      _accountUid = uid;
    } else {
      throw ArgumentError.value(uid, "uid $uid did not exist", "uid");
    }
  }

  List<String> getAccountList() {
    List<String> uidList = [];
    accountList.forEach((String uid, AccountConfig account) {
      uidList.add(uid);
    });
    return uidList;
  }

  void addAccount() {}

  AccountConfig getLoggedAccount() {
    return accountList[_accountUid]!;
  }

  AccountConfig getAccount(uid) {
    return accountList[uid]!;
  }
}

class AccountConfig {
  final String _uid;
  String cookie;
  String? userid;
  String? password;
  String? displayname;
  bool rememberLoginInfo = false;
  AccountConfig(this._uid, {this.cookie = ""});

  Future setCookie(String value) async {
    return await setLoginSession("cookie", cookie = value, _uid);
  }

  Future setUserId(String value) async {
    return await setLoginSession("userid", userid = value, _uid);
  }

  Future setPassword(String value) async {
    await setLoginSession("password", password = value, _uid);
  }

  Future setDisplayName(String value) async {
    return await setLoginSession("displayname", userid = value, _uid);
  }

  Future setRememberLoginInfo(bool value) async {
    return await setLoginSession("remember_login_info", (rememberLoginInfo = value) ? "true" : "false", _uid);
  }

  Future removeCookie() async {
    cookie = "";
    return await removeLoginSession("cookie", _uid);
  }

  Future removePassword() async {
    password = null;
    return await removeLoginSession("password", _uid);
  }

  Future removeDisplayName() async {
    displayname = null;
    return await removeLoginSession("displayname", _uid);
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
