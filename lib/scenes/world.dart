// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;

  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  late Column column = Column(
    children: <Widget>[
      Text(AppLocalizations.of(context)!.loading),
    ],
  );
  late List<Widget> popupMenu = [share(context, "https://vrchat.com/home/user/${widget.worldId}")];

  _WorldState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).worlds(widget.worldId).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        setState(() {
          column = Column(children: [
            world(context, response),
            TextButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => VRChatMobileJsonViewer(obj: response),
                    ));
              },
              child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
            ),
          ]);
        });
        getLoginSession("LoginSession").then((cookie) {
          VRChatAPI(cookie: cookie).favoriteGroups("world", offset: 0).then((response) {
            List<Widget> bottomSheet = [];
            if (response.containsKey("error")) {
              error(context, response["error"]["message"]);
              return;
            }
            if (response.isEmpty) return;
            bottomSheet.add(ListTile(
              title: Text(AppLocalizations.of(context)!.addFavoriteWorlds),
            ));
            bottomSheet.add(const Divider());
            response.forEach((dynamic index, dynamic list) {
              bottomSheet.add(ListTile(
                title: Text(list["displayName"]),
                onTap: () => {
                  VRChatAPI(cookie: cookie).addFavorites("world", widget.worldId, list["name"]).then((response) {
                    if (response.containsKey("error")) {
                      error(context, response["error"]["message"]);
                      return;
                    }
                    Navigator.pop(context);
                  })
                },
              ));
              bottomSheet.add(const Divider());
            });
            bottomSheet.removeLast();
            setState(() {
              popupMenu = <Widget>[share(context, "https://vrchat.com/home/user/${widget.worldId}"), worldAction(context, widget.worldId, bottomSheet)];
            });
          });
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world), actions: popupMenu),
      drawer: drawr(context),
      body: SafeArea(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(30), child: column))),
    );
  }
}
