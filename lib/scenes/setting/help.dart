// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/license.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/share.dart';

final vrchatMobileVersionProvider = FutureProvider((ref) async => await PackageInfo.fromPlatform());

class VRChatMobileHelp extends ConsumerWidget {
  const VRChatMobileHelp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    textStream(context: context, forceExternal: accessibilityConfig.forceExternalBrowser);
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
                  onTap: () async {
                    Widget? value = await openInBrowser(
                      url: Uri.https("github.com", "/fa0311/vrc_manager"),
                      forceExternal: accessibilityConfig.forceExternalBrowser,
                    );
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => value),
                      );
                    }
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.report),
                  subtitle: Text(AppLocalizations.of(context)!.reportDetails),
                  onTap: () async {
                    Widget? value = await openInBrowser(
                      url: Uri.https("github.com", "/fa0311/vrc_manager/issues/new/choose"),
                      forceExternal: accessibilityConfig.forceExternalBrowser,
                    );
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => value),
                      );
                    }
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.developerInfo),
                  subtitle: Text(AppLocalizations.of(context)!.developerInfoDetails),
                  onTap: () async {
                    Widget? value = await openInBrowser(
                      url: Uri.https("twitter.com", "/faa0311"),
                      forceExternal: accessibilityConfig.forceExternalBrowser,
                    );
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => value),
                      );
                    }
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.rateTheApp),
                  subtitle: Text(AppLocalizations.of(context)!.rateTheAppDetails),
                  onTap: () async {
                    Widget? value = await openInBrowser(
                      url: Uri.https("play.google.com", "/store/apps/details", {"id": "com.yuki0311.vrc_manager"}),
                      forceExternal: accessibilityConfig.forceExternalBrowser,
                    );
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => value),
                      );
                    }
                  },
                ),
                version.when(
                  loading: () => ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 2, top: 2),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (e, trace) {
                    logger.w(getMessage(e), e, trace);
                    return ListTile(
                      title: Text(AppLocalizations.of(context)!.version),
                      subtitle: Text(AppLocalizations.of(context)!.error),
                    );
                  },
                  data: (data) => ListTile(
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text(AppLocalizations.of(context)!.versionDetails(data.version)),
                    onTap: () async {
                      Widget? value = await openInBrowser(
                        url: Uri.https("github.com", "/fa0311/vrc_manager/releases"),
                        forceExternal: accessibilityConfig.forceExternalBrowser,
                      );
                      if (value != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => value),
                        );
                      }
                    },
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
