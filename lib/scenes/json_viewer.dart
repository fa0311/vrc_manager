import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';

class VRChatMobileJsonViewer extends StatefulWidget {
  final dynamic obj;
  const VRChatMobileJsonViewer({Key? key, required this.obj}) : super(key: key);

  @override
  State<VRChatMobileJsonViewer> createState() => _JsonViewerPageState();
}

class _JsonViewerPageState extends State<VRChatMobileJsonViewer> {
  String theme = "light";
  _JsonViewerPageState() {
    getStorage("theme_brightness").then((response) {
      setState(() => theme = response ?? "light");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('JSONビューワー'),
        ),
        body: Container(
          color: theme == "dark" ? Colors.black : Colors.white,
          child: SafeArea(
              child: ListView(children: [
            JsonViewer(widget.obj),
          ])),
        ));
  }
}
