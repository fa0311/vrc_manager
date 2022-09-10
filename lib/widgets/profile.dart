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

Column profile(BuildContext context, AppConfig appConfig, VRChatAPI vrhatLoginSession, VRChatUser user) {
  List<InlineSpan> lineList = [];
  for (String line in (user.bio ?? "").split('\n')) {
    Match? matchTwitter = RegExp(r'^(Twitter|twitter|TWITTER)([:˸：\s]{0,3})([@＠\s]{0,3})([0-9０-９a-zA-Z_]{1,15})$').firstMatch(line);
    Match? matchDiscord = RegExp(r'^(Discord|discord|DISCORD)([:˸：\s]{1,3})(.{1,16}[#＃][0-9０-９]{4})$').firstMatch(line);
    Match? matchGithub = RegExp(r'^(Github|github|GITHUB)([:˸：\s]{1,3})([0-9０-９a-zA-Z_]{1,38})$').firstMatch(line);
    Match? matchUrl = RegExp(r'^([0-9０-９a-zA-Z_]{2,16})([:˸：\s]{1,3})(https?[:˸][/⁄]{2}.+)$').firstMatch(line);
    Match? match = matchTwitter ?? matchDiscord ?? matchGithub ?? matchUrl;
    if (match != null) {
      String text = "";
      lineList.add(TextSpan(text: match.group(1)));
      lineList.add(TextSpan(text: match.group(2)));
      for (int i = 3; i <= match.groupCount; i++) {
        text += match.group(i)!;
      }
      lineList.add(TextSpan(
          text: "$text\n",
          style: const TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (matchTwitter != null) {
                shareModalBottom(context, appConfig, vrhatLoginSession, "https://twitter.com/${match.group(match.groupCount)}");
              } else if (matchDiscord != null) {
                clipboardShareModalBottom(context, "${match.group(match.groupCount)}".replaceAll("＃", "#"));
              } else if (matchGithub != null) {
                shareModalBottom(context, appConfig, vrhatLoginSession, "https://github.com/${match.group(match.groupCount)}");
              } else if (matchUrl != null) {
                shareModalBottom(
                    context, appConfig, vrhatLoginSession, "${match.group(match.groupCount)}".replaceAll("⁄", "/").replaceAll("˸", ":").replaceAll("․", "."));
              }
            }));
    } else {
      lineList.add(TextSpan(text: "$line\n"));
    }
  }

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
              children: lineList,
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
          vrhatLoginSession,
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

Widget profileAction(BuildContext context, AppConfig appConfig, VRChatAPI vrhatLoginSession, VRChatfriendStatus status, String uid, Function reload) {
  sendFriendRequest() {
    vrhatLoginSession.sendFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, vrhatLoginSession, status);
    });
  }

  acceptFriendRequest() {
    vrhatLoginSession.acceptFriendRequestByUid(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, vrhatLoginSession, status);
    });
  }

  deleteFriendRequest() {
    vrhatLoginSession.deleteFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, appConfig, vrhatLoginSession, status);
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
              apiError(context, appConfig, vrhatLoginSession, status);
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

List<Widget> _biolink(BuildContext context, AppConfig appConfig, VRChatAPI vrhatLoginSession, List<dynamic> biolinks) {
  List<Widget> response = [];
  for (String link in biolinks) {
    if (link == "") continue;
    response.add(
      CircleAvatar(
        backgroundColor: const Color(0x00000000),
        child: IconButton(
          onPressed: () => openInBrowser(context, appConfig, vrhatLoginSession, link),
          icon: SvgPicture.asset("assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20, height: 20, color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF), semanticsLabel: link),
        ),
      ),
    );
  }
  return response;
}
