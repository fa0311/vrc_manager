// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;

  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  late Column column = Column(children: const [Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())]);
  late List<Widget> popupMenu = [share(context, "https://vrchat.com/home/world/${widget.worldId}")];

  _WorldState() {
    getLoginSession("login_session").then((cookie) {
      VRChatAPI(cookie: cookie ?? "").worlds(widget.worldId).then((response) {
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
        getLoginSession("login_session").then((cookie) {
          VRChatAPI(cookie: cookie ?? "").favoriteGroups("world", offset: 0).then((response) {
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
                  VRChatAPI(cookie: cookie ?? "").addFavorites("world", widget.worldId, list["name"]).then((response) {
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
              popupMenu = <Widget>[worldAction(context, widget.worldId, bottomSheet), share(context, "https://vrchat.com/home/world/${widget.worldId}")];
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
      body: SafeArea(child: SizedBox(width: MediaQuery.of(context).size.width, child: SingleChildScrollView(child: column))),
    );
  }
}
