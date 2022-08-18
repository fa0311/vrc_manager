// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/worlds.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;

  const VRChatMobileWorldsFavorite({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  List<int> offset = [];
  List<FavoriteWorlds> dataColumn = [];

  List<Widget> bodyList = [];
  List<VRChatFavoriteGroup> favoriteList = [];
  String? cookie;

  _WorldsFavoriteState() {
    getLoginSession("login_session").then(
      (String? response) {
        VRChatAPI(cookie: cookie = response ?? "").favoriteGroups("world", offset: 0).then((
          VRChatFavoriteGroupList response,
        ) {
          final List<Widget> children = [];
          for (VRChatFavoriteGroup list in response.group) {
            children.add(Column(
              children: <Widget>[
                Text(list.displayName),
              ],
            ));
          }
          response.group.asMap().forEach((index, VRChatFavoriteGroup list) {
            offset.add(0);
            bodyList.add(Column());
            dataColumn.add(FavoriteWorlds()..context = context);
            favoriteList.add(list);
            moreOver(index);
          });
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  bool canMoreOver(int index) {
    return (dataColumn[index].worldList.length == offset[index]);
  }

  moreOver(int index) {
    offset[index] += 50;
    VRChatAPI(cookie: cookie ?? "").favoritesWorlds(favoriteList[index].name, offset: offset[index] - 50).then((VRChatFavoriteWorldList worlds) {
      List<Future> futureList = [];
      for (VRChatFavoriteWorld world in worlds.world) {
        dataColumn[index].add(world);
        futureList.add(
          VRChatAPI(cookie: cookie ?? "").worlds(world.id).then((VRChatWorld world) {
            dataColumn[index].descriptionMap[world.id] = world.description;
          }).catchError((status) {
            apiError(context, status);
          }),
        );
      }
      Future.wait(futureList).then((value) {
        setState(
          () => reload(index),
        );
      });
    }).catchError((status) {
      apiError(context, status);
    });
  }

  reload(int index) {
    setState(
      () => bodyList[index] = Column(
        children: [
          Text(favoriteList[index].displayName),
          dataColumn[index].render(children: dataColumn[index].reload()),
          if (canMoreOver(index))
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.readMore),
                    onPressed: () => moreOver(index),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    dataColumn.asMap().forEach((index, FavoriteWorlds data) {
      data.button = () {
        reload(index);
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteWorlds),
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child: Column(children: bodyList)),
        ),
      ),
    );
  }
}
