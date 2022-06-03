import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/assets/vrchat/icon.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

Column profile(user) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 250,
        child: Image.network(user["profilePicOverride"] == "" ? user["currentAvatarImageUrl"] : user["profilePicOverride"], fit: BoxFit.fitWidth),
      ),
      Container(padding: const EdgeInsets.only(top: 10)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          status(user["state"] == "offline" ? user["state"] : user["status"]),
          Container(
            width: 5,
          ),
          Text(user["displayName"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      if (user["statusDescription"] != "") Text(user["statusDescription"]),
      ConstrainedBox(constraints: const BoxConstraints(maxHeight: 200), child: SingleChildScrollView(child: Text(user["bio"]))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: _biolink(user["bioLinks"] ?? [])),
      if (user["last_login"] != "") Text("最終ログイン:${generalDateDifference(user["last_login"])}"),
      Text("登録日:${generalDateDifference(user["date_joined"])}"),
    ],
  );
}

Widget profileAction(BuildContext context, status, String uid) {
  void sendFriendRequest() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).sendFriendRequest(uid).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VRChatMobileUser(userId: uid),
            ),
            (_) => false);
      });
    });
  }

  void deleteFriendRequest() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).deleteFriendRequest(uid).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VRChatMobileUser(userId: uid),
            ),
            (_) => false);
      });
    });
  }

  void deleteFriend() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("フレンドを解除しますか？"),
          actions: <Widget>[
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("解除"),
              onPressed: () => getLoginSession("LoginSession").then((cookie) {
                VRChatAPI(cookie: cookie).deleteFriend(uid).then((response) {
                  if (response.containsKey("error")) {
                    error(context, response["error"]["message"]);
                    return;
                  }
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VRChatMobileUser(userId: uid),
                      ),
                      (_) => false);
                });
              }),
            ),
          ],
        );
      },
    );
  }

  return SpeedDial(
    icon: Icons.add,
    activeIcon: Icons.close,
    children: [
      if (!status["isFriend"] && !status["incomingRequest"] && !status["outgoingRequest"])
        SpeedDialChild(
          child: const Icon(Icons.person_add),
          label: 'フレンドリクエスト',
          onTap: sendFriendRequest,
        ),
      if (status["isFriend"] && !status["incomingRequest"] && !status["outgoingRequest"])
        SpeedDialChild(
          child: const Icon(Icons.person_remove),
          label: 'フレンド解除',
          onTap: deleteFriend,
        ),
      if (!status["isFriend"] && status["incomingRequest"])
        SpeedDialChild(
          child: const Icon(Icons.person_remove),
          label: 'フレンド拒否',
          onTap: deleteFriendRequest,
        ),
      if (!status["isFriend"] && status["incomingRequest"])
        SpeedDialChild(
          child: const Icon(Icons.person_add),
          label: 'フレンド許可',
          onTap: sendFriendRequest,
        ),
    ],
  );
}

List<Widget> _biolink(List biolinks) {
  List<Widget> response = [];
  for (String link in biolinks) {
    if (link == "") continue;
    response.add(CircleAvatar(
        backgroundColor: const Color(0x00000000),
        child: IconButton(
          onPressed: () {
            _launchURL() async {
              if (await canLaunch(link)) {
                await launch(link);
              }
            }

            _launchURL();
          },
          icon: SvgPicture.asset("assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20, height: 20, color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF), semanticsLabel: link),
        )));
    continue;
  }
  return response;
}
