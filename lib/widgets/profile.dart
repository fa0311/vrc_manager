// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/assets/dialog.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/vrchat/icon.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/share.dart';
import 'package:vrc_manager/widgets/status.dart';

List<InlineSpan> textToAnchor(BuildContext context, String text) {
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
                    if (isUrl) modalBottom(context, shareUrlListTile(context, text!));
                  }
                  ..onLongPressCancel = () {
                    if (DateTime.now().millisecondsSinceEpoch - timeStamp < 500) {
                      if (isUrl) {
                        openInBrowser(context, text!);
                      } else {
                        copyToClipboard(context, text!);
                      }
                    }
                  })
          ];
        }
        return [TextSpan(text: "$line\n")];
      }(),
    ],
  ];
}

Row username(VRChatUser user, {double diameter = 20}) {
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

Column profile(BuildContext context, VRChatUser user) {
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
              children: textToAnchor(context, user.bio ?? ""),
              style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _bioLink(context, user.bioLinks),
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

editBio(BuildContext context, Function setState, TextEditingController controller, VRChatUserSelf user) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editBio),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () => vrchatLoginSession.changeBio(user.id, user.bio = controller.text).then((VRChatUserSelf response) {
              Navigator.pop(context);
              setState(() => user.bio = user.bio == "" ? null : user.bio);
            }).catchError((status) {
              apiError(context, status);
            }),
          ),
        ],
      );
    },
  );
}

editNote(BuildContext context, Function setState, TextEditingController controller, VRChatUser user) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editNote),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () => vrchatLoginSession.userNotes(user.id, user.note = controller.text).then((VRChatUserNotes response) {
              Navigator.pop(context);
              setState(() => user.note = user.note == "" ? null : user.note);
            }).catchError((status) {
              apiError(context, status);
            }),
          ),
        ],
      );
    },
  );
}

Widget profileAction(BuildContext context, VRChatFriendStatus status, String uid, Function reload) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");

  sendFriendRequest() {
    vrchatLoginSession.sendFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, status);
    });
  }

  acceptFriendRequest() {
    vrchatLoginSession.acceptFriendRequestByUid(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, status);
    });
  }

  deleteFriendRequest() {
    vrchatLoginSession.deleteFriendRequest(uid).then((response) {
      Navigator.pop(context);
      reload();
    }).catchError((status) {
      apiError(context, status);
    });
  }

  deleteFriend() {
    confirm(
        context,
        AppLocalizations.of(context)!.unfriendConfirm,
        AppLocalizations.of(context)!.unfriend,
        () => vrchatLoginSession.deleteFriend(uid).then((response) {
              Navigator.pop(context);
              Navigator.pop(context);
              reload();
            }).catchError((status) {
              apiError(context, status);
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
                  title: Text(AppLocalizations.of(context)!.requestCancel),
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

List<Widget> _bioLink(BuildContext context, List<Uri> bioLinks) {
  return [
    for (Uri link in bioLinks)
      InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openInBrowser(context, link.toString()),
        onLongPress: () => modalBottom(context, shareUrlListTile(context, link.toString())),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Ink(
            child: SvgPicture.asset(
              "assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20,
              height: 20,
              color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF),
              semanticsLabel: link.toString(),
            ),
          ),
        ),
      ),
  ];
}
