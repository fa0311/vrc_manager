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
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/web_view.dart';

IconButton share(BuildContext context, AppConfig appConfig, String url) {
  return IconButton(
    icon: const Icon(Icons.share),
    onPressed: () => shareModalBottom(context, appConfig, url),
  );
}

shareModalBottom(BuildContext context, AppConfig appConfig, String url) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.share),
              onTap: () {
                Share.share(url);
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.copy),
              title: Text(AppLocalizations.of(context)!.copy),
              onTap: () {
                final ClipboardData data = ClipboardData(text: url);
                Clipboard.setData(data).then(
                  (_) {
                    if (Platform.isAndroid || Platform.isIOS) {
                      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
                    }
                    Navigator.pop(context);
                  },
                );
              }),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: Text(AppLocalizations.of(context)!.openInBrowser),
            onTap: () {
              Navigator.pop(context);
              openInBrowser(context, appConfig, url);
            },
          ),
        ],
      ),
    ),
  );
}

IconButton simpleShare(BuildContext context, String url) {
  return IconButton(
    icon: const Icon(Icons.share),
    onPressed: () => simpleShareModalBottom(context, url),
  );
}

simpleShareModalBottom(BuildContext context, String url) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.share),
              onTap: () {
                Share.share(url);
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.copy),
              title: Text(AppLocalizations.of(context)!.copy),
              onTap: () {
                final ClipboardData data = ClipboardData(text: url);
                Clipboard.setData(data).then(
                  (_) {
                    if (Platform.isAndroid || Platform.isIOS) {
                      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
                    }
                    Navigator.pop(context);
                  },
                );
              }),
          if (Uri.parse(url).host != "vrchat.com")
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(AppLocalizations.of(context)!.openInExternalBrowser),
              onTap: () async {
                Navigator.pop(context);
                if (await canLaunchUrl(
                  Uri.parse(url),
                )) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                }
              },
            ),
        ],
      ),
    ),
  );
}

IconButton clipboardShare(BuildContext context, String text) {
  return IconButton(
    icon: const Icon(Icons.share),
    onPressed: () => clipboardShareModalBottom(context, text),
  );
}

clipboardShareModalBottom(BuildContext context, String text) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.copy),
              title: Text(AppLocalizations.of(context)!.copy),
              onTap: () {
                final ClipboardData data = ClipboardData(text: text);
                Clipboard.setData(data).then(
                  (_) {
                    if (Platform.isAndroid || Platform.isIOS) {
                      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
                    }
                    Navigator.pop(context);
                  },
                );
              }),
        ],
      ),
    ),
  );
}

lunchWorldModalBottom(BuildContext context, AppConfig appConfig, String worldId, String instanceId) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.getLoggedAccount().cookie);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.share),
              title: Text(AppLocalizations.of(context)!.share),
              onTap: () {
                Share.share("https://vrchat.com/home/launch?worldId=$worldId&instanceId=$instanceId");
              }),
          ListTile(
              leading: const Icon(Icons.copy),
              title: Text(AppLocalizations.of(context)!.copy),
              onTap: () {
                final ClipboardData data = ClipboardData(text: "https://vrchat.com/home/launch?worldId=$worldId&instanceId=$instanceId");
                Clipboard.setData(data).then(
                  (_) {
                    if (Platform.isAndroid || Platform.isIOS) {
                      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              }),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: Text(AppLocalizations.of(context)!.openInExternalBrowser),
            onTap: () {
              openInBrowser(context, appConfig, "https://vrchat.com/home/launch?worldId=$worldId&instanceId=$instanceId");
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(AppLocalizations.of(context)!.joinInstance),
            onTap: () => vrhatLoginSession
                .shortName("$worldId:$instanceId")
                .then(
                  (VRChatSecureName secureId) => vrhatLoginSession
                      .selfInvite("$worldId:$instanceId", secureId.shortName ?? secureId.secureName ?? "")
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
          ),
          if (Platform.isWindows)
            ListTile(
              leading: const Icon(Icons.laptop_windows),
              title: Text(AppLocalizations.of(context)!.openInVrchat),
              onTap: () {
                openInBrowser(context, appConfig, "vrchat://launch?ref=vrchat.com&id=$worldId:$instanceId");
              },
            ),
        ],
      ),
    ),
  );
}

Future<void> openInBrowser(BuildContext context, AppConfig appConfig, String url) async {
  if (Platform.isAndroid || Platform.isIOS) {
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
