// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/dialog.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/assets/vrchat/icon.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

Column profile(BuildContext context, VRChatUser user) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 250,
        child:
            Image.network(user.profilePicOverride ?? user.currentAvatarImageUrl, fit: BoxFit.fitWidth, errorBuilder: (BuildContext context, _, __) => Column()),
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
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: Text(user.bio ?? ""),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _biolink(
          context,
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

Widget profileAction(BuildContext context, Map status, String uid) {
  sendFriendRequest() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").sendFriendRequest(uid).then(
          (response) {
            if (response.containsKey("error")) {
              error(context, response["error"]["message"]);
              return;
            }
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: uid),
              ),
            );
          },
        );
      },
    );
  }

  deleteFriendRequest() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").deleteFriendRequest(uid).then(
          (response) {
            if (response.containsKey("error")) {
              error(context, response["error"]["message"]);
              return;
            }
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileUser(userId: uid),
              ),
            );
          },
        );
      },
    );
  }

  deleteFriend() {
    confirm(
      context,
      AppLocalizations.of(context)!.unfriendConfirm,
      AppLocalizations.of(context)!.unfriend,
      () => getLoginSession("login_session").then(
        (cookie) {
          VRChatAPI(cookie: cookie ?? "").deleteFriend(uid).then(
            (response) {
              if (response.containsKey("error")) {
                error(context, response["error"]["message"]);
                return;
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileUser(userId: uid),
                ),
              );
            },
          );
        },
      ),
    );
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
              if (!status["isFriend"] && !status["incomingRequest"] && !status["outgoingRequest"])
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text(AppLocalizations.of(context)!.friendRequest),
                  onTap: sendFriendRequest,
                ),
              if (status["isFriend"] && !status["incomingRequest"] && !status["outgoingRequest"])
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(AppLocalizations.of(context)!.unfriend),
                  onTap: deleteFriend,
                ),
              if (!status["isFriend"] && status["incomingRequest"])
                ListTile(
                  leading: const Icon(Icons.person_remove),
                  title: Text(AppLocalizations.of(context)!.denyFriends),
                  onTap: deleteFriendRequest,
                ),
              if (!status["isFriend"] && status["incomingRequest"])
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: Text(AppLocalizations.of(context)!.allowFriends),
                  onTap: sendFriendRequest,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

List<Widget> _biolink(BuildContext context, List<dynamic> biolinks) {
  List<Widget> response = [];
  for (String link in biolinks) {
    if (link == "") continue;
    response.add(
      CircleAvatar(
        backgroundColor: const Color(0x00000000),
        child: IconButton(
          onPressed: () => openInBrowser(context, link),
          icon: SvgPicture.asset("assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20, height: 20, color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF), semanticsLabel: link),
        ),
      ),
    );
  }
  return response;
}
