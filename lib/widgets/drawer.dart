import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/friend_request.dart';
import 'package:vrchat_mobile_client/scenes/friends.dart';
import 'package:vrchat_mobile_client/scenes/help.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/scenes/settings.dart';
import 'package:vrchat_mobile_client/scenes/worlds_favorite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Drawer drawr(BuildContext context) {
  return Drawer(
    child: SafeArea(
      child: Column(children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileHome(),
                      ));
                },
                leading: const Icon(Icons.home),
                title: Text(AppLocalizations.of(context)!.home),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileFriends(offline: false),
                      ));
                },
                leading: const Icon(Icons.wb_sunny),
                title: Text(AppLocalizations.of(context)!.onlineFrends),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileFriends(offline: true),
                      ));
                },
                leading: const Icon(Icons.bedtime),
                title: Text(AppLocalizations.of(context)!.offlineFrends),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileFriendRequest(),
                      ));
                },
                leading: const Icon(Icons.notifications),
                title: Text(AppLocalizations.of(context)!.offlineFrends),
              ),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.close),
              )
            ],
          ),
        ),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              children: <Widget>[
                const Divider(),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const VRChatMobileSettings(),
                          ));
                    },
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.setting)),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const VRChatMobileHelp()));
                    },
                    leading: const Icon(Icons.help),
                    title: Text(AppLocalizations.of(context)!.help))
              ],
            )),
      ]),
    ),
  );
}
