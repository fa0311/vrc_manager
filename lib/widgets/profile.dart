// Dart imports:

// Dart imports:

// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/dialog.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/vrchat/icon.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

List<InlineSpan> textToAnchor(BuildContext context, AppConfig appConfig, String text) {
  return [
    for (String line in text.split('\n')) ...[
      ...() {
        bool isUrl = true;
        Match? match;
        String? text = () {
          match = RegExp(r'^(Twitter|twitter|TWITTER)([:˸：\s]{0,3})([@＠\s]{0,3})([0-9０-９a-zA-Z_]{1,15})$').firstMatch(line);
          if (match != null) return "https://twitter.com/${match!.group(match!.groupCount)}";
          match = RegExp(r'^(Github|github|GITHUB)([:˸：\s]{1,3})([0-9０-９a-zA-Z_]{1,38})$').firstMatch(line);
          if (match != null) return "https://github.com/${match!.group(match!.groupCount)}";
          match = RegExp(r'^([0-9０-９a-zA-Z_]{2,16})([:˸：\s]{1,3})(https?[:˸][/⁄]{2}.+)$').firstMatch(line);
          if (match != null) return "https://twitter.com/${match!.group(match!.groupCount)}";
          isUrl = false;
          match = RegExp(r'^(Discord|discord|DISCORD)([:˸：\s]{1,3})(.{1,16}[#＃][0-9０-９]{4})$').firstMatch(line);
          if (match != null) return "${match!.group(match!.groupCount)}".replaceAll("＃", "#");
        }();
        if (match != null) {
          late int timeStamp = 0;
          return [
            TextSpan(text: "${match!.group(1)}${match!.group(2)}"),
            TextSpan(
                text: "${[for (int i = 3; i <= match!.groupCount; i++) match!.group(i)!].join()}\n",
                style: const TextStyle(color: Colors.blue),
                recognizer: LongPressGestureRecognizer()
                  ..onLongPressDown = ((details) => timeStamp = DateTime.now().millisecondsSinceEpoch)
                  ..onLongPress = () {
                    if (isUrl) {
                      openInBrowser(context, appConfig, text!);
                    } else {
                      copyToClipboard(context, text!);
                    }
                  }
                  ..onLongPressCancel = () {
                    if (isUrl && DateTime.now().millisecondsSinceEpoch - timeStamp < 500) {
                      modalBottom(context, shareUrlListTile(context, appConfig, text!));
                    }
                  })
          ];
        }
        return [TextSpan(text: "$line\n")];
      }(),
    ],
  ];
}

Row username(VRChatFriends user, {double diameter = 20}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      status(user.state == "offline" ? user.state! : user.status, diameter: diameter - 2),
      Padding(
        padding: const EdgeInsets.only(left: 2, right: 5),
        child: Text(
          user.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: diameter,
          ),
        ),
      ),
    ],
  );
}

Column profile(BuildContext context, AppConfig appConfig, VRChatFriends user) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 250,
        child: CachedNetworkImage(
          imageUrl: user.profilePicOverride ?? user.currentAvatarImageUrl,
          fit: BoxFit.fitWidth,
          progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
            width: 250,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox(
            width: 250.0,
            child: Icon(Icons.error),
          ),
        ),
      ),
      Container(padding: const EdgeInsets.only(top: 10)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          status(user.state == "offline" ? user.state! : user.status),
          Container(
            width: 5,
          ),
          Text(user.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ],
      ),
      Text(user.statusDescription ?? ""),
      if (user.note != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
          child: Text(user.note ?? ""),
        ),
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              children: textToAnchor(context, appConfig, user.bio ?? ""),
              style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _biolink(
          context,
          appConfig,
          user.bioLinks,
        ),
      ),
      if (user.lastLogin != null)
        Text(
          AppLocalizations.of(context)!.lastLogin(
            generalDateDifference(context, user.lastLogin!),
          ),
        ),
      if (user.dateJoined != null)
        Text(
          AppLocalizations.of(context)!.dateJoined(
            generalDateDifference(context, user.dateJoined!),
          ),
        ),
    ],
  );
}

Widget profileAction(BuildContext context, AppConfig appConfig, VRChatfriendStatus status, String uid, Function reload) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");

  sendFriendRequest() {
    vrhatLoginSession.sendFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, status);
    });
  }

  acceptFriendRequest() {
    vrhatLoginSession.acceptFriendRequestByUid(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, status);
    });
  }

  deleteFriendRequest() {
    vrhatLoginSession.deleteFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, status);
    });
  }

  deleteFriend() {
    confirm(
        context,
        AppLocalizations.of(context)!.unfriendConfirm,
        AppLocalizations.of(context)!.unfriend,
        () => vrhatLoginSession.deleteFriend(uid).then((response) {
              Navigator.pop(context);
              Navigator.pop(context);
              reload();
            }).catchError((status) {
              apiError(context, appConfig, status);
            }));
  }

  return IconButton(
    icon: const Icon(Icons.add),
    onPressed: () => showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
          child: Column(
            children: [
              if (!status.isFriend && !status.incomingRequest && !status.outgoingRequest)
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text(AppLocalizations.of(context)!.friendRequest),
                  onTap: sendFriendRequest,
                ),
              if (status.isFriend && !status.incomingRequest && !status.outgoingRequest)
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(AppLocalizations.of(context)!.unfriend),
                  onTap: deleteFriend,
                ),
              if (!status.isFriend && status.outgoingRequest)
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(AppLocalizations.of(context)!.unrequested),
                  onTap: deleteFriendRequest,
                ),
              if (!status.isFriend && status.incomingRequest)
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text(AppLocalizations.of(context)!.allowFriends),
                  onTap: acceptFriendRequest,
                ),
              if (!status.isFriend && status.incomingRequest)
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(AppLocalizations.of(context)!.denyFriends),
                  onTap: deleteFriendRequest,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

List<Widget> _biolink(BuildContext context, AppConfig appConfig, List<dynamic> biolinks) {
  List<Widget> response = [];
  for (String link in biolinks) {
    if (link == "") continue;
    response.add(
      CircleAvatar(
        backgroundColor: const Color(0x00000000),
        child: IconButton(
          onPressed: () => openInBrowser(context, appConfig, link),
          icon: SvgPicture.asset("assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20, height: 20, color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF), semanticsLabel: link),
        ),
      ),
    );
  }
  return response;
}
