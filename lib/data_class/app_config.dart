// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/data_class/modal.dart';

class AppConfig {
  AccountConfig? _loggedAccount;
  List<AccountConfig> accountList = [];
  GridConfigList gridConfigList = GridConfigList();
  bool dontShowErrorDialog = false;
  bool agreedUserPolicy = false;
  final themeBrightness = StateNotifierProvider<ThemeBrightnessNotifier, ThemeBrightness>((_) => ThemeBrightnessNotifier());

  LanguageCode languageCode = LanguageCode.en;
  bool forceExternalBrowser = false;
  bool debugMode = false;

  AccountConfig? get loggedAccount => _loggedAccount;

  Future<bool> get(BuildContext context, WidgetRef ref) async {
    List uidList = [];
    String? accountUid;

    await Future.wait([
      ref.read(themeBrightness.notifier).get(),
      getStorage("language_code").then((value) => languageCode = value == null ? languageCode : LanguageCode.values.byName(value)),
    ]);
    await Future.wait([
      getStorage("account_index").then((value) => accountUid = value),
      getStorageList("account_index_list").then((List<String> value) => uidList = value),
      getStorage("dont_show_error_dialog").then((value) => dontShowErrorDialog = (value == "true")),
      getStorage("agreed_user_policy").then((value) => agreedUserPolicy = (value == "true")),
      getStorage("force_external_browser").then((value) => forceExternalBrowser = (value == "true")),
      getStorage("debug_mode").then((value) => debugMode = (value == "true")),
      gridConfigList.setConfig(),
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
    futureList.add(accountConfig.getFavoriteWorldGroups(
      context,
    ));
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

  Future setLanguageCode(LanguageCode value) async {
    return await setStorage("language_code", (languageCode = value).name);
  }

  Future setDontShowErrorDialog(bool value) async {
    return await setStorage("dont_show_error_dialog", (dontShowErrorDialog = value).toString());
  }

  Future setAgreedUserPolicy(bool value) async {
    return await setStorage("agreed_user_policy", (agreedUserPolicy = value).toString());
  }

  Future setForceExternalBrowser(bool value) async {
    return await setStorage("force_external_browser", (forceExternalBrowser = value).toString());
  }

  Future setDebugMode(bool value) async {
    return await setStorage("debug_mode", (debugMode = value).toString());
  }
}

class ThemeBrightnessNotifier extends StateNotifier<ThemeBrightness> {
  ThemeBrightnessNotifier() : super(ThemeBrightness.light);

  Future get() async {
    state = ThemeBrightness.values.byName(await getStorage("theme_brightness") ?? "");
  }

  Future set(ThemeBrightness element) async {
    await setStorage("theme_brightness", (state = element).name);
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

class GridConfigList {
  GridConfig onlineFriends = GridConfig("online_friends_config");
  GridConfig offlineFriends = GridConfig("offline_friends_config");
  GridConfig friendsRequest = GridConfig("friends_request_config");
  GridConfig searchUsers = GridConfig("search_users_config");
  GridConfig searchWorlds = GridConfig("search_worlds_config");
  GridConfig favoriteWorlds = GridConfig("favorite_worlds_config");

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(onlineFriends.setConfig());
    futureList.add(offlineFriends.setConfig());
    futureList.add(friendsRequest.setConfig());
    futureList.add(searchUsers.setConfig());
    futureList.add(searchWorlds.setConfig());
    futureList.add(favoriteWorlds.setConfig());
    return Future.wait(futureList);
  }
}

class GridConfig {
  late String id;
  late SortMode sortMode;
  late DisplayMode displayMode;
  late bool descending;
  late bool joinable;
  late bool worldDetails;
  late bool removeButton;

  GridConfig(this.id);

  Future setConfig() async {
    List<Future> futureList = [];
    futureList.add(getStorage("sort", id: id).then((String? value) => sortMode = SortMode.normal.get(value)));
    futureList.add(getStorage("display_mode", id: id).then((String? value) => displayMode = DisplayMode.normal.get(value)));
    futureList.add(getStorage("descending", id: id).then((String? value) => descending = (value == "true")));
    futureList.add(getStorage("joinable", id: id).then((String? value) => joinable = (value == "true")));
    futureList.add(getStorage("world_details", id: id).then((String? value) => worldDetails = (value == "true")));
    futureList.add(getStorage("remove_button", id: id).then((String? value) => removeButton = (value == "true")));

    return Future.wait(futureList);
  }

  Future setSort(SortMode value) async {
    sortMode = value;
    return await setStorage("sort", value.name, id: id);
  }

  Future setDisplayMode(DisplayMode value) async {
    displayMode = value;
    return await setStorage("display_mode", displayMode.name, id: id);
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

  Future setRemoveButton(bool value) async {
    return await setStorage("remove_button", (removeButton = value) ? "true" : "false", id: id);
  }
}
