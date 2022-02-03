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
    for (var user in tempUserList) {
      adds(user);
    }
    return children;
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
      children.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VRChatMobileUser(userId: user["id"]),
                ));
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 100,
                child:
                    Image.network(user["profilePicOverride"] == "" ? user["currentAvatarThumbnailImageUrl"] : user["profilePicOverride"], fit: BoxFit.fitWidth),
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
                Text(user["statusDescription"], style: const TextStyle(fontSize: 14)),
                if (!["", "private"].contains(user["location"]) && locationMap.containsKey(user["location"].split(":")[0]))
                  Text(locationMap[user["location"].split(":")[0]]["name"], style: const TextStyle(fontSize: 14)),
              ])),
            ],
          )));
    });
    return children;
  }
}
