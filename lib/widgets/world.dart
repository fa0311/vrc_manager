import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';

Card worldSlim(context, world) {
  return Card(
      elevation: 20.0,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VRChatMobileWorld(worldId: world["id"]),
                    ));
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Image.network(world["thumbnailImageUrl"], fit: BoxFit.fitWidth),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(children: [
                          SizedBox(width: double.infinity, child: Text(world["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                        ])),
                  )
                ],
              ))));
}

Card worldSlimPlus(context, world, instance) {
  return Card(
      elevation: 20.0,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VRChatMobileWorld(worldId: world["id"]),
                    ));
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: Image.network(world["thumbnailImageUrl"], fit: BoxFit.fitWidth),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(children: [
                          Row(children: [
                            Padding(padding: const EdgeInsets.only(right: 5), child: region(instance["region"])),
                            const Icon(Icons.groups),
                            Padding(
                                padding: const EdgeInsets.only(right: 5), child: Text(instance['n_users'].toString() + "/" + instance['capacity'].toString())),
                            Expanded(child: SizedBox(width: double.infinity, child: Text(getVrchatInstanceType()[instance["type"]] ?? "?")))
                          ]),
                          SizedBox(width: double.infinity, child: Text(world["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                        ])),
                  )
                ],
              ))));
}

Card privateWorldSlim() {
  return Card(
      elevation: 20.0,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
              child: Row(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.network("https://assets.vrchat.com/www/images/default_private_image.png", fit: BoxFit.fitWidth),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(children: const [
                      SizedBox(width: double.infinity, child: Text("Private")),
                      SizedBox(width: double.infinity, child: Text("プライベートワールド", style: TextStyle(fontWeight: FontWeight.bold))),
                    ])),
              )
            ],
          ))));
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
