// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/scenes/add_worlds_favorite.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/scenes/worlds_favorite.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';

Card worldSlim(BuildContext context, dynamic world) {
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
                        child: Column(children: <Widget>[
                          SizedBox(width: double.infinity, child: Text(world["name"], style: const TextStyle(fontWeight: FontWeight.bold))),
                        ])),
                  ),
                  if (world.containsKey("favoriteId"))
                    SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () {
                            getLoginSession("LoginSession").then((cookie) {
                              VRChatAPI(cookie: cookie).deleteFavorites(world["favoriteId"]).then((response) {
                                if (response.containsKey("error")) {
                                  error(context, response["error"]["message"]);
                                  return;
                                }
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VRChatMobileWorldsFavorite(),
                                    ));
                              });
                            });
                          },
                          icon: const Icon(Icons.delete),
                        )),
                ],
              ))));
}

Card worldSlimPlus(BuildContext context, dynamic world, dynamic instance) {
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
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
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
                    child: Column(children: const <Widget>[
                      SizedBox(width: double.infinity, child: Text("Private")),
                      SizedBox(width: double.infinity, child: Text("プライベートワールド", style: TextStyle(fontWeight: FontWeight.bold))),
                    ])),
              )
            ],
          ))));
}

Column world(dynamic world) {
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

Widget worldAction(BuildContext context, String wid) {
  return SpeedDial(
    icon: Icons.add,
    activeIcon: Icons.close,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.favorite),
        label: 'お気に入りに追加',
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VRChatMobileAddWorldsFavorite(worldId: wid),
              ));
        },
      ),
    ],
  );
}
