// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/licence.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

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
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Text(AppLocalizations.of(context)!.contribution),
                      subtitle: Text(AppLocalizations.of(context)!.contributionDetails),
                      onTap: () => openInBrowser(context, "https://github.com/fa0311/vrchat_mobile_client")),
                  const Divider(),
                  ListTile(
                      title: Text(AppLocalizations.of(context)!.report),
                      subtitle: Text(AppLocalizations.of(context)!.reportDetails),
                      onTap: () => openInBrowser(context, "https://github.com/fa0311/vrchat_mobile_client/issues/new/choose")),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.developerInfo),
                    subtitle: Text(AppLocalizations.of(context)!.developerInfoDetails),
                    onTap: () => openInBrowser(context, "https://twitter.com/faa0311"),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.rateTheApp),
                    subtitle: Text(AppLocalizations.of(context)!.rateTheAppDetails),
                    onTap: () => openInBrowser(context, "https://play.google.com/store/apps/details?id=com.yuki0311.vrchat_mobile_client"),
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
        ),
      ),
    );
  }
}
