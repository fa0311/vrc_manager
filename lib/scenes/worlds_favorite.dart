// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
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
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  _WorldsFavoriteState() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").favoriteGroups("world", offset: 0).then((
          VRChatFavoriteGroupList response,
        ) {
          if (response.group.isEmpty) {
            setState(() => column = Column(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.none),
                  ],
                ));
          } else {
            final List<Widget> children = [];
            for (VRChatFavoriteGroup list in response.group) {
              children.add(Column(
                children: <Widget>[
                  Text(list.displayName),
                ],
              ));
            }
            column = Column(children: children);
          }
          response.group.asMap().forEach((index, VRChatFavoriteGroup list) {
            offset.add(0);
            childrenList.add(Column());
            moreOver(list, index);
          });
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  moreOver(VRChatFavoriteGroup list, int index) {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").favoritesWorlds(list.name, offset: offset[index]).then((VRChatFavoriteWorldList worlds) {
          offset[index] += 50;
          final List<Widget> worldList = [];
          worldList.addAll(childrenList[index].children);
          for (VRChatFavoriteWorld world in worlds.world) {
            worldList.add(simpleWorldFavorite(context, world));
          }
          childrenList[index] = Column(children: worldList);
          column = Column(children: column.children);
          setState(
            () {
              column.children[index] = Column(children: [
                Text(list.displayName),
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
            },
          );
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteWorlds),
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child: column),
        ),
      ),
    );
  }
}
