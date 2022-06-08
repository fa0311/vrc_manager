// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;

  const VRChatMobileWorldsFavorite({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  List<int> offset = [];
  List<Column> childrenList = [];

  late Column column = Column(
    children: <Widget>[
      Text(AppLocalizations.of(context)!.loading),
    ],
  );

  _WorldsFavoriteState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).favoriteGroups("world", offset: 0).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        if (response.isEmpty) {
          setState(() => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ));
        } else {
          final List<Widget> children = [];
          response.forEach((dynamic index, dynamic list) {
            children.add(Column(
              children: <Widget>[
                Text(list["displayName"]),
              ],
            ));
          });
          column = Column(children: children);
        }
        response.forEach((dynamic index, dynamic list) {
          offset.add(0);
          childrenList.add(Column());
          moreOver(list, index);
        });
      });
    });
  }

  moreOver(Map list, int index) {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).favoritesWorlds(list["name"], offset: offset[index]).then((worlds) {
        if (worlds.containsKey("error")) {
          error(context, worlds["error"]["message"]);
          return;
        }

        offset[index] += 50;
        final List<Widget> worldList = [];
        worldList.addAll(childrenList[index].children);
        worlds.forEach((dynamic index, dynamic world) {
          worldList.add(worldSimple(context, world));
        });
        childrenList[index] = Column(children: worldList);
        column = Column(children: column.children);
        setState(() {
          column.children[index] = Column(children: [
            Text(list["displayName"]),
            Column(children: childrenList[index].children),
            if (childrenList[index].children.length == offset[index] && offset[index] > 0)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.readMore),
                      onPressed: () => moreOver(list, index),
                    ),
                  ],
                ),
              )
          ]);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.favoriteWorlds),
        ),
        drawer: drawr(context),
        body: SafeArea(child: SizedBox(width: MediaQuery.of(context).size.width, child: SingleChildScrollView(child: column))));
  }
}
