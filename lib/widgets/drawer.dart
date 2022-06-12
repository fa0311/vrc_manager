// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/friend_request.dart';
import 'package:vrchat_mobile_client/scenes/friends.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/scenes/setting/other_account.dart';
import 'package:vrchat_mobile_client/scenes/settings.dart';
import 'package:vrchat_mobile_client/scenes/worlds_favorite.dart';

Drawer? drawr(BuildContext context) {
  Column column = Column();

  getStorageList("account_index_list").then((response) {
    List<Widget> list = [
      const Divider(),
      ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const VRChatMobileSettingsOtherAccount(),
              ),
              (_) => false))
    ];
    response.asMap().forEach((_, String accountIndex) {
      getLoginSession("userid", accountIndex: accountIndex).then((accountName) => list.insert(
          0,
          ListTile(
              title: Text(accountName ?? "Unknown"),
              onTap: () => setStorage("account_index", accountIndex).then((response) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const VRChatMobileHome(),
                  ),
                  (_) => false)))));
    });
    column = Column(children: list);
  });

  return Drawer(
    child: SafeArea(
      child: Column(children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileHome(),
                    ),
                    (_) => false),
                leading: const Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.home),
              ),
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileFriends(offline: false),
                    ),
                    (_) => false),
                leading: const Icon(Icons.wb_sunny),
                title: Text(AppLocalizations.of(context)!.onlineFrends),
              ),
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileFriends(offline: true),
                    ),
                    (_) => false),
                leading: const Icon(Icons.bedtime),
                title: Text(AppLocalizations.of(context)!.offlineFrends),
              ),
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileFriendRequest(),
                    ),
                    (_) => false),
                leading: const Icon(Icons.notifications),
                title: Text(AppLocalizations.of(context)!.friendRequest),
              ),
              ListTile(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileWorldsFavorite(),
                    ),
                    (_) => false),
                leading: const Icon(Icons.favorite),
                title: Text(AppLocalizations.of(context)!.favoriteWorlds),
              ),
              /*
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileWorldsFavorite(),
                      ));
                },
                leading: const Icon(Icons.notifications),
                title: const Text('最近訪れたワールド'),
              ),
              */
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.close),
              )
            ],
          ),
        ),
        const Divider(),
        ListTile(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const VRChatMobileSettings(logged: true),
                ),
                (_) => false),
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.setting)),
        ListTile(
            onTap: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                builder: (BuildContext context) => SingleChildScrollView(child: column)),
            leading: const Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context)!.accountSwitch)),
      ]),
    ),
  );
}

Drawer simpleDrawr(BuildContext context) {
  Column column = Column();

  getStorageList("account_index_list").then((response) {
    List<Widget> list = [
      const Divider(),
      ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const VRChatMobileSettingsOtherAccount(),
              ),
              (_) => false))
    ];
    response.asMap().forEach((_, String accountIndex) {
      getLoginSession("userid", accountIndex: accountIndex).then((accountName) => list.insert(
          0,
          ListTile(
              title: Text(accountName ?? "Unknown"),
              onTap: () => setStorage("account_index", accountIndex).then((response) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const VRChatMobileHome(),
                  ),
                  (_) => false)))));
    });
    column = Column(children: list);
  });

  return Drawer(
    child: SafeArea(
      child: Column(children: <Widget>[
        Expanded(
            child: Column(children: <Widget>[
          ListTile(
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const VRChatMobileHome(),
                ),
                (_) => false),
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          )
        ])),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                const Divider(),
                ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const VRChatMobileSettings(logged: false),
                        ),
                        (_) => false),
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.setting)),
                ListTile(
                    onTap: () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        builder: (BuildContext context) => SingleChildScrollView(child: column)),
                    leading: const Icon(Icons.account_circle),
                    title: Text(AppLocalizations.of(context)!.accountSwitch)),
              ],
            )),
      ]),
    ),
  );
}
