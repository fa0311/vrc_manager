import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

class Users {
  List<Widget> children = [];
  late BuildContext context;
  late Map<String, dynamic> locationMap = {};
  late List<dynamic> userList = [];

  List<Widget> reload() {
    children = [];
    List<dynamic> tempUserList = userList;
    userList = [];
    for (var users in tempUserList) {
      adds(users);
    }
    return children;
  }

  num length() {
    num len = 0;
    for (var users in userList) {
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
      children.add(Card(
          elevation: 20.0,
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VRChatMobileUser(userId: user["id"]),
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
                          child: Column(children: [
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
                          const Text("ロード中", style: TextStyle(fontSize: 14)),
                        if (user["location"] == "private") const Text("プライベートワールド", style: TextStyle(fontSize: 14)),
                      ])),
                    ],
                  )))));
    });
    return children;
  }
}
