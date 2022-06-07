import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Widget? dial;

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
          dial = worldAction(context, widget.worldId);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world), actions: <Widget>[share("https://vrchat.com/home/world/${widget.worldId}")]),
      drawer: drawr(context),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: SingleChildScrollView(child: column))),
      floatingActionButton: dial,
    );
  }
}
