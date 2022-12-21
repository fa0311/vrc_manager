// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/license.dart';
import 'package:vrc_manager/widgets/share.dart';

final vrchatMobileVersionProvider = FutureProvider((ref) async => await PackageInfo.fromPlatform());

class VRChatMobileHelp extends ConsumerWidget {
  const VRChatMobileHelp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<PackageInfo> version = ref.watch(vrchatMobileVersionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context)!.contribution),
                  subtitle: Text(AppLocalizations.of(context)!.contributionDetails),
                  onTap: () => openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager")),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.report),
                  subtitle: Text(AppLocalizations.of(context)!.reportDetails),
                  onTap: () => openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager/issues/new/choose")),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.developerInfo),
                  subtitle: Text(AppLocalizations.of(context)!.developerInfoDetails),
                  onTap: () => openInBrowser(context, Uri.https("twitter.com", "/faa0311")),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.rateTheApp),
                  subtitle: Text(AppLocalizations.of(context)!.rateTheAppDetails),
                  onTap: () => openInBrowser(context, Uri.https("play.google.com", "/store/apps/details?id=com.yuki0311.vrc_manager")),
                ),
                version.when(
                  loading: () => ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 2, top: 2),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (err, stack) => ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text('Error: $err\n$stack'),
                  ),
                  data: (data) => ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text(AppLocalizations.of(context)!.versionDetails(data.version)),
                    onTap: () => openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager/releases")),
                  ),
                ),
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
    );
  }
}
