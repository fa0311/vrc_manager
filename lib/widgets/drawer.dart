// Flutter imports:

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/main.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/friend_request.dart';
import 'package:vrchat_mobile_client/scenes/friends.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/scenes/search.dart';
import 'package:vrchat_mobile_client/scenes/setting/other_account.dart';
import 'package:vrchat_mobile_client/scenes/settings.dart';
import 'package:vrchat_mobile_client/scenes/worlds_favorite.dart';

Drawer drawer(BuildContext context, AppConfig appConfig, VRChatAPI vrhatLoginSession) {
  Column column = Column();

  getStorageList("account_index_list").then(
    (response) {
      List<Widget> list = [
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileSettingsOtherAccount(appConfig, vrhatLoginSession),
            ),
            (_) => false,
          ),
        )
      ];
      response.asMap().forEach(
        (_, String accountUid) {
          getLoginSession("displayname", accountUid: accountUid).then(
            (accountName) => list.insert(
              0,
              ListTile(
                title: Text(
                  accountName ?? AppLocalizations.of(context)!.unknown,
                ),
                onTap: () => setStorage("account_index", accountUid).then(
                  (_) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileHome(appConfig, vrhatLoginSession),
                    ),
                    (_) => false,
                  ),
                ),
              ),
            ),
          );
        },
      );
      column = Column(children: list);
    },
  );

  return Drawer(
    child: SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileHome(appConfig, vrhatLoginSession),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.home),
                    title: Text(AppLocalizations.of(context)!.home),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileFriends(appConfig, vrhatLoginSession, offline: false),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.wb_sunny),
                    title: Text(AppLocalizations.of(context)!.onlinefriends),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileFriends(appConfig, vrhatLoginSession, offline: true),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.bedtime),
                    title: Text(AppLocalizations.of(context)!.offlinefriends),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatSearch(appConfig, vrhatLoginSession),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.search),
                    title: Text(AppLocalizations.of(context)!.search),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileFriendRequest(appConfig, vrhatLoginSession),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.notifications),
                    title: Text(AppLocalizations.of(context)!.friendRequest),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileWorldsFavorite(appConfig, vrhatLoginSession),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.favorite),
                    title: Text(AppLocalizations.of(context)!.favoriteWorlds),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ],
              ),
            ),
          ),
          if (MediaQuery.of(context).size.height > 500)
            Column(children: [
              const Divider(),
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileSettings(appConfig, vrhatLoginSession, logged: true),
                  ),
                  (_) => false,
                ),
                leading: const Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.setting),
              ),
              ListTile(
                onTap: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  builder: (BuildContext context) => SingleChildScrollView(child: column),
                ),
                leading: const Icon(Icons.account_circle),
                title: Text(AppLocalizations.of(context)!.accountSwitch),
              ),
            ]),
          if (MediaQuery.of(context).size.height <= 500)
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileSettings(appConfig, vrhatLoginSession, logged: true),
                    ),
                    (_) => false,
                  ),
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    builder: (BuildContext context) => SingleChildScrollView(child: column),
                  ),
                  icon: const Icon(Icons.account_circle),
                ),
              ],
            )
        ],
      ),
    ),
  );
}

Drawer simpledrawer(BuildContext context, AppConfig appConfig, VRChatAPI vrhatLoginSession) {
  Column column = Column();

  getStorageList("account_index_list").then(
    (response) {
      List<Widget> list = [
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileSettingsOtherAccount(appConfig, vrhatLoginSession),
            ),
            (_) => false,
          ),
        )
      ];
      response.asMap().forEach(
        (_, String accountUid) {
          getLoginSession("displayname", accountUid: accountUid).then(
            (accountName) => list.insert(
              0,
              ListTile(
                title: Text(
                  accountName ?? AppLocalizations.of(context)!.unknown,
                ),
                onTap: () => setStorage("account_index", accountUid).then(
                  (_) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileHome(appConfig, vrhatLoginSession),
                    ),
                    (_) => false,
                  ),
                ),
              ),
            ),
          );
        },
      );
      column = Column(children: list);
    },
  );

  return Drawer(
    child: SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(children: <Widget>[
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileHome(appConfig, vrhatLoginSession),
                  ),
                  (_) => false,
                ),
                leading: const Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.home),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              )
            ]),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                const Divider(),
                ListTile(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileSettings(appConfig, vrhatLoginSession, logged: false),
                    ),
                    (_) => false,
                  ),
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.setting),
                ),
                ListTile(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    builder: (BuildContext context) => SingleChildScrollView(child: column),
                  ),
                  leading: const Icon(Icons.account_circle),
                  title: Text(AppLocalizations.of(context)!.accountSwitch),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
