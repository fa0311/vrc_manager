// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/data_class.dart';

// Project imports:
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

class Users {
  List<Widget> children = [];
  bool joinable = false;
  late BuildContext context;
  Map<String, VRChatWorld> locationMap = {};
  List<VRChatUser> userList = [];

  List<Widget> reload() {
    children = [];
    List<VRChatUser> tempUserList = userList;
    userList = [];
    adds(tempUserList);
    return children;
  }

  Map<String, Map<String, int>> numberOfFriendsInLocation() {
    Map<String, Map<String, int>> inLocation = {};
    int id = 0;
    for (dynamic user in userList) {
      String location = user["location"];
      if (["private", "offline"].contains(location) && joinable) continue;
      if (inLocation[location] == null) {
        id++;
        inLocation[location] = {
          "id": id,
          "number": 0,
        };
      }
      inLocation[location]!["number"] = (inLocation[location]!["number"]! + 1);
    }

    return inLocation;
  }

  sortByLocationMap() {
    Map<String, Map<String, int>> inLocation = numberOfFriendsInLocation();

    userList.sort((userA, userB) {
      String locationA = userA.location;
      String locationB = userB.location;
      if (locationA == locationB) return 0;
      if (["private", "offline"].contains(locationA) && joinable) return 1;
      if (["private", "offline"].contains(locationB) && joinable) return -1;
      if (inLocation[locationA]!["number"]! > inLocation[locationB]!["number"]!) return -1;
      if (inLocation[locationA]!["number"]! < inLocation[locationB]!["number"]!) return 1;
      if (inLocation[locationA]!["id"]! > inLocation[locationB]!["id"]!) return -1;
      if (inLocation[locationA]!["id"]! < inLocation[locationB]!["id"]!) return 1;
      return 0;
    });
  }

  List<Widget> adds(List<VRChatUser> users) {
    for (VRChatUser user in users) {
      add(user);
    }
    return children;
  }

  List<Widget> add(VRChatUser user) {
    userList.add(user);
    if (["private", "offline"].contains(user.location) && joinable) return children;
    children.add(
      Card(
        elevation: 20.0,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  ));
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Image.network(user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
                      fit: BoxFit.fitWidth, errorBuilder: (BuildContext context, _, __) => Column()),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          status(user.status),
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
                      if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 14)),
                      if (!["private", "offline"].contains(user.location) && locationMap.containsKey(user.location.split(":")[0]))
                        Text(locationMap[user.location.split(":")[0]]!.name, style: const TextStyle(fontSize: 14)),
                      if (!["private", "offline"].contains(user.location) && !locationMap.containsKey(user.location.split(":")[0]))
                        const SizedBox(
                          height: 15.0,
                          width: 15.0,
                          child: CircularProgressIndicator(),
                        ),
                      if (user.location == "private")
                        Text(
                          AppLocalizations.of(context)!.privateWorld,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return children;
  }
}
