// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/web/web_view.dart';

Future modalBottom(BuildContext context, List<Widget> children) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: children,
      ),
    ),
  );
}

List<Widget> shareUrlListTile(BuildContext context, AppConfig appConfig, String url, {bool browserExternalForce = false}) {
  return [
    shareListTileWidget(context, url),
    copyListTileWidget(context, url),
    if (!browserExternalForce) openInBrowserListTileWidget(context, appConfig, url),
    if (Uri.parse(url).host != "vrchat.com" && browserExternalForce) openInBrowserExternalForceListTileWidget(context, appConfig, url),
  ];
}

List<Widget> shareWorldListTile(BuildContext context, AppConfig appConfig, String worldId, String instanceId) {
  String url = "https://vrchat.com/home/launch?worldId=$worldId&instanceId=$instanceId";
  return [
    shareListTileWidget(context, url),
    copyListTileWidget(context, url),
    openInBrowserListTileWidget(context, appConfig, url),
    if (Platform.isWindows) openInWindowsListTileWidget(context, appConfig, "vrchat://launch?ref=vrchat.com&id=$worldId:$instanceId"),
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
      });
}

Widget openInBrowserListTileWidget(BuildContext context, AppConfig appConfig, String url) {
  return ListTile(
    leading: const Icon(Icons.open_in_browser),
    title: Text(AppLocalizations.of(context)!.openInBrowser),
    onTap: () {
      Navigator.pop(context);
      openInBrowser(context, appConfig, url);
    },
  );
}

Widget openInBrowserExternalForceListTileWidget(BuildContext context, AppConfig appConfig, String url) {
  return ListTile(
    leading: const Icon(Icons.open_in_browser),
    title: Text(AppLocalizations.of(context)!.openInExternalBrowser),
    onTap: () async {
      Navigator.pop(context);
      openInBrowser(context, appConfig, url, forceExternal: true);
    },
  );
}

Widget inviteVrchatListTileWidget(BuildContext context, AppConfig appConfig, String location) {
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
            apiError(context, appConfig, status);
          }),
        )
        .catchError((status) {
      apiError(context, appConfig, status);
    }),
  );
}

Widget openInWindowsListTileWidget(BuildContext context, AppConfig appConfig, String url) {
  return ListTile(
    leading: const Icon(Icons.laptop_windows),
    title: Text(AppLocalizations.of(context)!.openInVrchat),
    onTap: () {
      Navigator.pop(context);
      openInBrowser(context, appConfig, url);
    },
  );
}

Future openInBrowser(BuildContext context, AppConfig appConfig, String url, {bool forceExternal = false}) async {
  if (!forceExternal && (Platform.isAndroid || Platform.isIOS)) {
    getStorage("force_external_browser").then(
      (response) async {
        if (response == "true" && Uri.parse(url).host != "vrchat.com") {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileWebView(appConfig, url: url),
            ),
          );
        }
      },
    );
  } else {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

Future copyToClipboard(BuildContext context, String text) async {
  final ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
  if (Platform.isAndroid || Platform.isIOS) {
    /*
    * To be fixed in the next stable version.
    * if(context.mounted)
    */
    // ignore: use_build_context_synchronously
    Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
  }
}
