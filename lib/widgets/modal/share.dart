// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/scenes/sub/json_viewer.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

List<Widget> shareUrlListTile(Uri url, {bool browserExternalForce = false}) {
  return [
    ShareListTileWidget(text: url.toString()),
    CopyListTileWidget(text: url.toString()),
    if (!browserExternalForce) OpenInBrowserListTileWidget(url: url),
    if (url.host != "vrchat.com" && browserExternalForce) OpenInBrowserExternalForceListTileWidget(url: url),
  ];
}

List<Widget> shareInstanceListTile(String worldId, String instanceId) {
  Uri url = Uri.https("vrchat.com", "/home/launch", {"worldId": worldId, "instanceId": instanceId});
  return [
    ShareListTileWidget(text: url.toString()),
    CopyListTileWidget(text: url.toString()),
    OpenInBrowserListTileWidget(url: url),
    if (Platform.isWindows)
      OpenInWindowsListTileWidget(url: Uri(scheme: "vrchat", path: "launch", queryParameters: {"ref": "vrchat.com", "id": "$worldId:$instanceId"})),
  ];
}

class ShareListTileWidget extends ConsumerWidget {
  final String text;
  const ShareListTileWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.share),
      title: Text(AppLocalizations.of(context)!.share),
      onTap: () {
        Share.share(text);
      },
    );
  }
}

class CopyListTileWidget extends ConsumerWidget {
  final String text;
  const CopyListTileWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.copy),
      title: Text(AppLocalizations.of(context)!.copy),
      onTap: () {
        Navigator.pop(context);
        copyToClipboard(context, text);
      },
    );
  }
}

class OpenInBrowserListTileWidget extends ConsumerWidget {
  final Uri url;
  const OpenInBrowserListTileWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.open_in_browser),
      title: Text(AppLocalizations.of(context)!.openInBrowser),
      onTap: () {
        Navigator.pop(context);
        openInBrowser(context, url);
      },
    );
  }
}

class OpenInBrowserExternalForceListTileWidget extends ConsumerWidget {
  final Uri url;
  const OpenInBrowserExternalForceListTileWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.open_in_browser),
      title: Text(AppLocalizations.of(context)!.openInExternalBrowser),
      onTap: () {
        Navigator.pop(context);
        openInBrowser(context, url, forceExternal: true);
      },
    );
  }
}

class OpenInJsonViewer extends ConsumerWidget {
  final dynamic content;
  const OpenInJsonViewer({super.key, this.content});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(accessibilityConfigProvider).debugMode) {
      return ListTile(
        title: Text(AppLocalizations.of(context)!.openInJsonViewer),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileJsonViewer(content: content),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

class ShareUrlTileWidget extends ConsumerWidget {
  final Uri url;
  const ShareUrlTileWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.share),
      onTap: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () {
            return Column(children: shareUrlListTile(url));
          },
        );
      },
    );
  }
}

class ShareInstanceTileWidget extends ConsumerWidget {
  final String worldId;
  final String instanceId;
  const ShareInstanceTileWidget({super.key, required this.worldId, required this.instanceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.share),
      onTap: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () {
            return Column(children: shareInstanceListTile(worldId, instanceId));
          },
        );
      },
    );
  }
}

class InviteVrchatListTileWidget extends ConsumerWidget {
  final String location;
  const InviteVrchatListTileWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider)!.cookie);

    return ListTile(
      leading: const Icon(Icons.mail),
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () async {
        VRChatSecureName secureId = await vrchatLoginSession.shortName(location);
        await vrchatLoginSession.selfInvite(location, secureId.shortName ?? secureId.secureName ?? "");

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.sendInvite),
              content: Text(AppLocalizations.of(context)!.selfInviteDetails),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class OpenInWindowsListTileWidget extends ConsumerWidget {
  final Uri url;
  const OpenInWindowsListTileWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.laptop_windows),
      title: Text(AppLocalizations.of(context)!.openInVrchat),
      onTap: () {
        Navigator.pop(context);
        openInBrowser(context, url);
      },
    );
  }
}
