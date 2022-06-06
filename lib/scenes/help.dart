import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/licence.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            children: <Widget>[
              ListTile(
                title: const Text('報告'),
                subtitle: const Text('開発者にバグの報告や新機能のリクエストをします'),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl))) {
                    await launchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl));
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('開発者情報'),
                subtitle: const Text('開発者情報のアカウントを表示'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VRChatMobileUser(userId: "usr_e4c94acd-b8d2-4dfa-92db-57365a32ab1b"),
                      ));
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('評価する'),
                subtitle: const Text('GooglePlayStoreでの評価をお願いします'),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.yuki0311.vrchat_mobile_client"))) {
                    await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.yuki0311.vrchat_mobile_client"));
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Licence'),
                subtitle: const Text('Licence情報を確認します'),
                onTap: () {
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
