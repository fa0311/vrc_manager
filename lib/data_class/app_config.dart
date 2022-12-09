// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/data_class/notifier.dart';
import 'package:vrc_manager/l10n/code.dart';

final dontShowErrorDialogProvider = StateNotifierProvider<BooleanNotifier, bool>((_) => BooleanNotifier("dont_show_error_dialog"));
final agreedUserPolicyProvider = StateNotifierProvider<BooleanNotifier, bool>((_) => BooleanNotifier("agreed_user_policy"));
final forceExternalBrowserProvider = StateNotifierProvider<BooleanNotifier, bool>((_) => BooleanNotifier("force_external_browser"));
final debugModeProvider = StateNotifierProvider<BooleanNotifier, bool>((_) => BooleanNotifier("debug_mode"));
final themeBrightnessProvider = StateNotifierProvider<ThemeBrightnessNotifier, ThemeBrightness>((_) => ThemeBrightnessNotifier("theme_brightness"));
final languageCodeProvider = StateNotifierProvider<LanguageCodeNotifier, LanguageCode>((_) => LanguageCodeNotifier("language_code"));

class AppConfig {
  AccountConfig? _loggedAccount;
  List<AccountConfig> accountList = [];

  AccountConfig? get loggedAccount => _loggedAccount;

  Future<bool> get(BuildContext context, WidgetRef ref) async {
    List uidList = [];
    String? accountUid;

    await Future.wait([
      ref.read(themeBrightnessProvider.notifier).get(),
      ref.read(languageCodeProvider.notifier).get(),
    ]);
    await Future.wait([
      getStorage("account_index").then((value) => accountUid = value),
      getStorageList("account_index_list").then((List<String> value) => uidList = value),
      ref.read(dontShowErrorDialogProvider.notifier).get(),
      ref.read(agreedUserPolicyProvider.notifier).get(),
      ref.read(forceExternalBrowserProvider.notifier).get(),
      ref.read(debugModeProvider.notifier).get(),
    ]);

    List<Future> futureList = [];
    for (String uid in uidList) {
      AccountConfig accountConfig = AccountConfig(uid);
      futureList.add(getLoginSession("cookie", uid).then((value) => accountConfig.cookie = value ?? ""));
      futureList.add(getLoginSession("user_id", uid).then((value) => accountConfig.userId = value ?? ""));
      futureList.add(getLoginSession("password", uid).then((value) => accountConfig.password = value ?? ""));
      futureList.add(getLoginSession("display_name", uid).then((value) => accountConfig.displayName = value ?? ""));
      futureList.add(getLoginSession("remember_login_info", uid).then((value) => accountConfig.rememberLoginInfo = (value == "true")));
      accountList.add(accountConfig);
      if (uid == accountUid) {
        _loggedAccount = accountConfig;
      }
    }
    await Future.wait(futureList);
    if (_loggedAccount == null) return false;
    if (!(await _loggedAccount!.tokenCheck())) return false;

    /*
    * To be fixed in the next stable version.
    * if(context.mounted)
    */
    // ignore: use_build_context_synchronously
    await _loggedAccount!.getFavoriteWorldGroups(context);
    return true;
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

    if (_loggedAccount == account) {
      if (accountList.isEmpty) {
        futureList.add(logout());
      } else {
        _loggedAccount = accountList.first;
      }
    }
    return Future.wait(futureList);
  }

  Future<bool> logout() async {
    _loggedAccount = null;
    return await removeStorage("account_index");
  }

  Future<bool> login(BuildContext context, AccountConfig accountConfig) async {
    List<Future> futureList = [];
    _loggedAccount = accountConfig;
    accountConfig.favoriteWorld = [];
    if (!(await _loggedAccount!.tokenCheck())) return false;
    futureList.add(accountConfig.getFavoriteWorldGroups(context));
    futureList.add(setStorage("account_index", accountConfig.uid));
    await Future.wait(futureList);
    return true;
  }

  bool isLogout() {
    return _loggedAccount != null;
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
  String? userId;
  String? password;
  String? displayName;
  bool rememberLoginInfo = false;
  List<FavoriteWorldData> favoriteWorld = [];
  AccountConfig(this.uid);

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

  Future<bool> tokenCheck() async {
    late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: cookie);
    return await vrchatLoginSession.user().then((VRChatUserSelfOverload response) {
      setDisplayName(response.displayName);
      return true;
    }).catchError((status) {
      return false;
    });
  }

  Future getFavoriteWorldGroups(BuildContext context) async {
    late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: cookie);
    List<Future> futureList = [];
    int len = 0;
    do {
      int offset = favoriteWorld.length;
      await vrchatLoginSession.favoriteGroups("world", offset: offset).then((List<VRChatFavoriteGroup> favoriteGroupList) {
        for (VRChatFavoriteGroup group in favoriteGroupList) {
          FavoriteWorldData favorite = FavoriteWorldData(group);
          /*
         * To be fixed in the next stable version.
         * if(context.mounted)
         */
          // ignore: use_build_context_synchronously
          futureList.add(getFavoriteWorld(context, favorite));
          favoriteWorld.add(favorite);
        }
        len = favoriteGroupList.length;
      }).catchError((status) {
        apiError(context, status);
      });
    } while (len == 50);
  }

  Future getFavoriteWorld(BuildContext context, FavoriteWorldData favoriteWorld) async {
    late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: cookie);
    int len;
    do {
      int offset = favoriteWorld.list.length;
      List<VRChatFavoriteWorld> worlds = await vrchatLoginSession.favoritesWorlds(favoriteWorld.group.name, offset: offset).catchError((status) {
        apiError(context, status);
      });
      for (VRChatFavoriteWorld world in worlds) {
        favoriteWorld.list.add(world);
      }
      len = worlds.length;
    } while (len == 50);
  }
}

class FavoriteWorldData {
  final VRChatFavoriteGroup _group;
  final List<VRChatFavoriteWorld> _list = [];

  VRChatFavoriteGroup get group => _group;
  List<VRChatFavoriteWorld> get list => _list;

  FavoriteWorldData(this._group);
}
