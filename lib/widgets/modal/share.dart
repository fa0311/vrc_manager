// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/sub/json_viewer.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

class ShareUrlListTile extends ConsumerWidget {
  final Uri url;
  final bool browserExternalForce;

  const ShareUrlListTile({
    super.key,
    required this.url,
    this.browserExternalForce = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShareListTileWidget(text: url.toString()),
          CopyListTileWidget(text: url.toString()),
          if (!browserExternalForce) OpenInBrowserListTileWidget(url: url),
          if (url.host != VRChatAssets.vrchat.host && browserExternalForce) OpenInBrowserExternalForceListTileWidget(url: url),
        ],
      ),
    );
  }
}

class ShareInstanceListTile extends ConsumerWidget {
  final String worldId;
  final String instanceId;

  const ShareInstanceListTile({super.key, required this.worldId, required this.instanceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Uri url = VRChatAssets.launch.replace(queryParameters: {"worldId": worldId, "instanceId": instanceId});

    return SingleChildScrollView(
      child: Column(
        children: [
          ShareListTileWidget(text: url.toString()),
          CopyListTileWidget(text: url.toString()),
          OpenInBrowserListTileWidget(url: url),
          if (Platform.isWindows)
            OpenInWindowsListTileWidget(
                url: VRChatAssets.vrchatScheme.replace(path: "launch", queryParameters: {"ref": VRChatAssets.vrchat.host, "id": "$worldId:$instanceId"})),
        ],
      ),
    );
  }
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
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    return ListTile(
      leading: const Icon(Icons.open_in_browser),
      title: Text(AppLocalizations.of(context)!.openInBrowser),
      onTap: () async {
        Navigator.pop(context);
        Widget? value = await openInBrowser(
          url: url,
          forceExternal: accessibilityConfig.forceExternalBrowser,
        );
        if (value != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => value),
          );
        }
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
      onTap: () async {
        Navigator.pop(context);
        Widget? value = await openInBrowser(
          url: url,
          forceExternal: true,
        );
        if (value != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => value),
          );
        }
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
          builder: () => ShareUrlListTile(url: url),
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
          builder: () => ShareInstanceListTile(worldId: worldId, instanceId: instanceId),
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
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");

    return ListTile(
      leading: const Icon(Icons.mail),
      title: Text(AppLocalizations.of(context)!.joinInstance),
      onTap: () async {
        VRChatSecureName secureId = await vrchatLoginSession.shortName(location).catchError((e) {
          logger.e(getMessage(e), e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
        });
        await vrchatLoginSession.selfInvite(location, secureId.shortName ?? secureId.secureName ?? "").catchError((e) {
          logger.e(getMessage(e), e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
        });

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
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);

    return ListTile(
      leading: const Icon(Icons.laptop_windows),
      title: Text(AppLocalizations.of(context)!.openInVrchat),
      onTap: () async {
        Navigator.pop(context);
        Widget? value = await openInBrowser(
          url: url,
          forceExternal: accessibilityConfig.forceExternalBrowser,
        );
        if (value != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => value),
          );
        }
      },
    );
  }
}
