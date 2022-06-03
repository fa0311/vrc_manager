import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;

  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  Column column = Column(
    children: const <Widget>[
      Text('ロード中です'),
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
          column = Column(children: [world(response)]);
          dial = worldAction(context, widget.worldId);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ワールド'), actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
                child: ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('共有'),
                    onTap: () {
                      Share.share("https://vrchat.com/home/world/${widget.worldId}");
                      Navigator.pop(context);
                    })),
            PopupMenuItem(
                child: ListTile(
                    leading: const Icon(Icons.copy),
                    title: const Text('コピー'),
                    onTap: () async {
                      final data = ClipboardData(text: "https://vrchat.com/home/world/${widget.worldId}");
                      await Clipboard.setData(data).then((value) => Navigator.pop(context));
                    })),
            PopupMenuItem(
                child: ListTile(
                    leading: const Icon(Icons.web),
                    title: const Text('ブラウザで開く'),
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse("https://vrchat.com/home/world/${widget.worldId}"))) {
                        await launchUrl(Uri.parse("https://vrchat.com/home/world/${widget.worldId}"));
                      }
                    })),
          ],
        )
      ]),
      drawer: drawr(context),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(30), child: SingleChildScrollView(child: column))),
      floatingActionButton: dial,
    );
  }
}
