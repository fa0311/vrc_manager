import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

Column profile(user) {
  return Column(
    children: [
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
      Text("最終ログイン:" + generalDateDifference(user["last_login"])),
      Text("登録日:" + generalDateDifference(user["date_joined"])),
    ],
  );
}
