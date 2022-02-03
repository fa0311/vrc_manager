import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/friends.dart';
import 'package:vrchat_mobile_client/scenes/help.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/scenes/settings.dart';

Drawer drawr(context) {
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
                        builder: (context) => const VRChatMobileHome(),
                      ));
                },
                leading: const Icon(Icons.home),
                title: const Text('ホーム'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VRChatMobileFriends(offline: false),
                      ));
                },
                leading: const Icon(Icons.wb_sunny),
                title: const Text('オンラインのフレンド'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VRChatMobileFriends(offline: true),
                      ));
                },
                leading: const Icon(Icons.bedtime),
                title: const Text('オフラインのフレンド'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('閉じる'),
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
                            builder: (context) => const VRChatMobileSettings(),
                          ));
                    },
                    leading: const Icon(Icons.settings),
                    title: const Text('設定')),
                ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VRChatMobileHelp()));
                    },
                    leading: const Icon(Icons.help),
                    title: const Text('ヘルプ'))
              ],
            )),
      ]),
    ),
  );
}
