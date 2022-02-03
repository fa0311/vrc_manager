import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/friends.dart';
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
                title: const Text('My Page'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VRChatMobileFriends(),
                      ));
                },
                title: const Text('Friends'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
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
                const ListTile(leading: Icon(Icons.help), title: Text('Help'))
              ],
            )),
      ]),
    ),
  );
}
