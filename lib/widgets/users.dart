import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Users {
  List<Widget> children = [];
  bool joinable = false;
  late BuildContext context;
  late Map<String, dynamic> locationMap = {};
  late List<dynamic> userList = [];

  List<Widget> reload() {
    children = [];
    List<dynamic> tempUserList = userList;
    userList = [];
    for (Map users in tempUserList) {
      adds(users);
    }
    return children;
  }

  int length() {
    int len = 0;
    for (Map users in userList) {
      len += users.length;
    }
    return len;
  }

  List<Widget> adds(Map users) {
    // リストは低画質、単体だと高画質を表示させる
    // 低画質 currentAvatarThumbnailImageUrl
    // 高画質 currentAvatarImageUrl
    // オリジナル profilePicOverride

    // 低画質 thumbnailImageUrl
    // 高画質 imageUrl
    // オリジナル profilePicOverride
    userList.add(users);
    users.forEach((dynamic index, dynamic user) {
      if (["", "private", "offline"].contains(user["location"]) && joinable) return;

      children.add(Card(
          elevation: 20.0,
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VRChatMobileUser(userId: user["id"]),
                        ));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        child: Image.network(
                            user.containsKey("profilePicOverride")
                                ? user["profilePicOverride"] == ""
                                    ? user["currentAvatarThumbnailImageUrl"]
                                    : user["profilePicOverride"]
                                : user["currentAvatarThumbnailImageUrl"],
                            fit: BoxFit.fitWidth),
                      ),
                      Expanded(
                          child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            status(user["status"]),
                            Container(
                              width: 5,
                            ),
                            Text(user["displayName"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                        if (user["statusDescription"] != "") Text(user["statusDescription"], style: const TextStyle(fontSize: 14)),
                        if (!["", "private", "offline"].contains(user["location"]) && locationMap.containsKey(user["location"].split(":")[0]))
                          Text(locationMap[user["location"].split(":")[0]]["name"], style: const TextStyle(fontSize: 14)),
                        if (!["", "private", "offline"].contains(user["location"]) && !locationMap.containsKey(user["location"].split(":")[0]))
                          Text(AppLocalizations.of(context)!.loading, style: const TextStyle(fontSize: 14)),
                        if (user["location"] == "private") Text(AppLocalizations.of(context)!.privateWorld, style: const TextStyle(fontSize: 14)),
                      ])),
                    ],
                  )))));
    });
    return children;
  }
}
