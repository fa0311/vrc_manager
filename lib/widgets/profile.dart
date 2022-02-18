import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/vrchat/icon.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      Row(mainAxisAlignment: MainAxisAlignment.center, children: _biolink(user["bioLinks"] ?? [])),
      if (user["last_login"] != "") Text("最終ログイン:" + generalDateDifference(user["last_login"])),
      Text("登録日:" + generalDateDifference(user["date_joined"])),
    ],
  );
}

Column profileAction(user) {
  return Column(children: [
    ElevatedButton(child: const Text('ログイン'), onPressed: () => {}),
  ]);
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
