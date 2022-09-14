class AppConfig {
  late String? accountUid;
  late List<AccountConfig> accountList = [];

  AccountConfig? getLoggedAccount() {
    for (AccountConfig account in accountList) {
      if (account.accountUid == accountUid) {
        return account;
      }
    }
    return null;
  }
}

class AccountConfig {
  String accountUid;
  String cookie;
  String? userid;
  String? username;
  String? password;
  bool rememberLoginInfo = false;
  AccountConfig(this.accountUid, {this.cookie = ""});
}
