// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/main/friend_request.dart';
import 'package:vrc_manager/scenes/main/friends.dart';
import 'package:vrc_manager/scenes/main/home.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/main/settings.dart';
import 'package:vrc_manager/scenes/main/worlds_favorite.dart';
import 'package:vrc_manager/scenes/sub/login.dart';

Drawer drawer(BuildContext context, AppConfig appConfig) {
  List<Widget> getAccountList() {
    return [
      for (AccountConfig account in appConfig.accountList)
        ListTile(
          title: Text(
            account.displayName ?? AppLocalizations.of(context)!.unknown,
          ),
          onTap: () {
            Navigator.pop(context);
            appConfig.login(context, account).then(
                  (bool logged) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => logged ? VRChatMobileHome(appConfig) : VRChatMobileLogin(appConfig),
                    ),
                    (_) => false,
                  ),
                );
          },
        ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => VRChatMobileSettingsOtherAccount(appConfig),
          ),
          (_) => false,
        ),
      )
    ];
  }

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
                        builder: (BuildContext context) => VRChatMobileHome(appConfig),
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
                        builder: (BuildContext context) => VRChatMobileFriends(appConfig, offline: false),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.wb_sunny),
                    title: Text(AppLocalizations.of(context)!.onlineFriends),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileFriends(appConfig, offline: true),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.bedtime),
                    title: Text(AppLocalizations.of(context)!.offlineFriends),
                  ),
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatSearch(
                          appConfig,
                        ),
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
                        builder: (BuildContext context) => VRChatMobileFriendRequest(
                          appConfig,
                        ),
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
                        builder: (BuildContext context) => VRChatMobileWorldsFavorite(
                          appConfig,
                        ),
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
                    builder: (BuildContext context) => VRChatMobileSettings(appConfig),
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
                  builder: (BuildContext context) => SingleChildScrollView(
                    child: Column(children: getAccountList()),
                  ),
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
                      builder: (BuildContext context) => VRChatMobileSettings(appConfig),
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
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Column(children: getAccountList()),
                    ),
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

Drawer simpleDrawer(BuildContext context, AppConfig appConfig) {
  List<Widget> getAccountList() {
    return [
      for (AccountConfig account in appConfig.accountList)
        ListTile(
          title: Text(
            account.displayName ?? AppLocalizations.of(context)!.unknown,
          ),
          onTap: () {
            Navigator.pop(context);
            appConfig.login(context, account).then(
                  (bool logged) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => logged ? VRChatMobileHome(appConfig) : VRChatMobileLogin(appConfig),
                    ),
                    (_) => false,
                  ),
                );
          },
        ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => VRChatMobileSettingsOtherAccount(appConfig),
          ),
          (_) => false,
        ),
      ),
    ];
  }

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
                    builder: (BuildContext context) => VRChatMobileHome(
                      appConfig,
                    ),
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
                      builder: (BuildContext context) => VRChatMobileSettings(appConfig),
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
                    builder: (BuildContext context) => SingleChildScrollView(
                      child: Column(children: getAccountList()),
                    ),
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
