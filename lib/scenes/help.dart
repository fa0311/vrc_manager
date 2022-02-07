import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/licence.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class VRChatMobileHelp extends StatefulWidget {
  const VRChatMobileHelp({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHelp> createState() => _HelpPageState();
}

class _HelpPageState extends State<VRChatMobileHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ヘルプ'),
      ),
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('報告'),
                onPressed: () {
                  _launchURL() async {
                    if (await canLaunch("https://github.com/fa0311/vrchat_mobile_client/issues/new")) {
                      await launch("https://github.com/fa0311/vrchat_mobile_client/issues/new");
                    }
                  }

                  _launchURL();
                },
              ),
              ElevatedButton(
                child: const Text('Licence'),
                onPressed: () {
                  showLicence(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
