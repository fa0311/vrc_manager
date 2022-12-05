// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/license.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileHelp extends StatefulWidget {
  const VRChatMobileHelp({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHelp> createState() => _HelpPageState();
}

class _HelpPageState extends State<VRChatMobileHelp> {
  String version = "";
  _HelpPageState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
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
                      onTap: () => openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager"))),
                  const Divider(),
                  ListTile(
                      title: Text(AppLocalizations.of(context)!.report),
                      subtitle: Text(AppLocalizations.of(context)!.reportDetails),
                      onTap: () => openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager/issues/new/choose"))),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.developerInfo),
                    subtitle: Text(AppLocalizations.of(context)!.developerInfoDetails),
                    onTap: () => openInBrowser(context, Uri.https("twitter.com", "/faa0311")),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.rateTheApp),
                    subtitle: Text(AppLocalizations.of(context)!.rateTheAppDetails),
                    onTap: () => openInBrowser(context, Uri.https("play.google.com", "/store/apps/details?id=com.yuki0311.vrc_manager")),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text(AppLocalizations.of(context)!.versionDetails(version)),
                    onTap: () => PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                      openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager/releases"));
                    }),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.license),
                    subtitle: Text(AppLocalizations.of(context)!.licenseDetails),
                    onTap: () => showLicense(context),
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
