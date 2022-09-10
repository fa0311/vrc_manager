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
  late String accountUid;
  late String? cookie;
  late String userid;
  late String password;
  late bool rememberLoginInfo;
  AccountConfig(this.accountUid);
}
