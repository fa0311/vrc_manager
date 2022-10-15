// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/sub/json_viewer.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/share.dart';

List<Widget> shareUrlListTile(BuildContext context, String url, {bool browserExternalForce = false}) {
  return [
    shareListTileWidget(context, url),
    copyListTileWidget(context, url),
    if (!browserExternalForce) openInBrowserListTileWidget(context, url),
    if (Uri.parse(url).host != "vrchat.com" && browserExternalForce) openInBrowserExternalForceListTileWidget(context, url),
  ];
}

List<Widget> shareInstanceListTile(BuildContext context, String worldId, String instanceId) {
  String url = "https://vrchat.com/home/launch?worldId=$worldId&instanceId=$instanceId";
  return [
    shareListTileWidget(context, url),
    copyListTileWidget(context, url),
    openInBrowserListTileWidget(context, url),
    if (Platform.isWindows) openInWindowsListTileWidget(context, "vrchat://launch?ref=vrchat.com&id=$worldId:$instanceId"),
  ];
}

Widget shareListTileWidget(BuildContext context, String text) {
  return ListTile(
    leading: const Icon(Icons.share),
    title: Text(AppLocalizations.of(context)!.share),
    onTap: () {
      Navigator.pop(context);
      Share.share(text);
    },
  );
}

Widget copyListTileWidget(BuildContext context, String text) {
  return ListTile(
    leading: const Icon(Icons.copy),
    title: Text(AppLocalizations.of(context)!.copy),
    onTap: () {
      Navigator.pop(context);
      copyToClipboard(context, text);
    },
  );
}

Widget openInBrowserListTileWidget(BuildContext context, String url) {
  return ListTile(
    leading: const Icon(Icons.open_in_browser),
    title: Text(AppLocalizations.of(context)!.openInBrowser),
    onTap: () {
      Navigator.pop(context);
      openInBrowser(context, url);
    },
  );
}

Widget openInBrowserExternalForceListTileWidget(BuildContext context, String url) {
  return ListTile(
    leading: const Icon(Icons.open_in_browser),
    title: Text(AppLocalizations.of(context)!.openInExternalBrowser),
    onTap: () {
      Navigator.pop(context);
      openInBrowser(context, url, forceExternal: true);
    },
  );
}

Widget openInJsonViewer(BuildContext context, dynamic content) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.openInJsonViewer),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileJsonViewer(obj: content),
        ),
      );
    },
  );
}

Widget shareUrlTileWidget(BuildContext context, String url) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.share),
    onTap: () {
      modalBottom(context, shareUrlListTile(context, url));
    },
  );
}

Widget shareInstanceTileWidget(BuildContext context, String worldId, String instanceId) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.shareInstance),
    onTap: () {
      modalBottom(context, shareInstanceListTile(context, worldId, instanceId));
    },
  );
}

Widget inviteVrchatListTileWidget(BuildContext context, String location) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  return ListTile(
    leading: const Icon(Icons.mail),
    title: Text(AppLocalizations.of(context)!.joinInstance),
    onTap: () => vrchatLoginSession
        .shortName(location)
        .then(
          (VRChatSecureName secureId) => vrchatLoginSession
              .selfInvite(location, secureId.shortName ?? secureId.secureName ?? "")
              .then(
                (VRChatNotificationsInvite response) => showDialog(
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
                ),
              )
              .catchError((status) {
            apiError(context, status);
          }),
        )
        .catchError((status) {
      apiError(context, status);
    }),
  );
}

Widget openInWindowsListTileWidget(BuildContext context, String url) {
  return ListTile(
    leading: const Icon(Icons.laptop_windows),
    title: Text(AppLocalizations.of(context)!.openInVrchat),
    onTap: () {
      Navigator.pop(context);
      openInBrowser(context, url);
    },
  );
}
