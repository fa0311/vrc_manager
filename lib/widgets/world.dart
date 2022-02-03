import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';

GestureDetector worldSlim(context, world) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VRChatMobileWorld(worldId: world["id"]),
            ));
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Image.network(world["thumbnailImageUrl"], fit: BoxFit.fitWidth),
          ),
          Container(padding: const EdgeInsets.only(top: 10)),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(children: [
                  SizedBox(width: double.infinity, child: Text(world["releaseStatus"])),
                  SizedBox(width: double.infinity, child: Text(world["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                ])),
          )
        ],
      ));
}

Column world(world) {
  return Column(children: <Widget>[
    SizedBox(
      height: 250,
      child: Image.network(world["imageUrl"], fit: BoxFit.fitWidth),
    ),
    Text(world["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
    ConstrainedBox(constraints: const BoxConstraints(maxHeight: 200), child: SingleChildScrollView(child: Text(world["description"]))),
    Text("プレイヤー数:" + world["occupants"].toString()),
    Text("プライベート:" + world["privateOccupants"].toString()),
    Text("いいね:" + world["favorites"].toString()),
    Text("作成:" + generalDateDifference(world["created_at"])),
    Text("最終更新:" + generalDateDifference(world["updated_at"])),
  ]);
}
