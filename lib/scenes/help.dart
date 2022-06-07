// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/licence.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

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
        title: Text(AppLocalizations.of(context)!.help),
      ),
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.report),
                subtitle: Text(AppLocalizations.of(context)!.reportDetails),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl))) {
                    await launchUrl(Uri.parse(AppLocalizations.of(context)!.issueUrl));
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.developerInfo),
                subtitle: Text(AppLocalizations.of(context)!.developerInfoDetails),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const VRChatMobileUser(userId: "usr_e4c94acd-b8d2-4dfa-92db-57365a32ab1b"),
                      ));
                },
              ),
              const Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.rateTheApp),
                subtitle: Text(AppLocalizations.of(context)!.rateTheAppDetails),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.yuki0311.vrchat_mobile_client"))) {
                    await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.yuki0311.vrchat_mobile_client"));
                  }
                },
              ),
              const Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.licence),
                subtitle: Text(AppLocalizations.of(context)!.licenceDetails),
                onTap: () => showLicence(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
