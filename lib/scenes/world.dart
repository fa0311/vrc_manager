// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/assets/vrchat/region.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;
  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );
  late List<Widget> popupMenu = [share(context, "https://vrchat.com/home/world/${widget.worldId}")];

  String genRandHex([int length = 32]) {
    const charset = '0123456789ABCDEF';
    final random = Random.secure();
    final randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
  }

  String genRandNumber([int length = 5]) {
    const charset = '0123456789';
    final random = Random.secure();
    final randomStr = List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
  }

  genInstanceId(String region, String type, bool canRequestInvite) async {
    String? cookie = await getLoginSession("login_session");
    VRChatUserOverload user = await VRChatAPI(cookie: cookie ?? "").user().catchError((status) {
      apiError(context, status);
    });
    String url = genRandNumber();

    if (["hidden", "friends", "private"].contains(type)) {
      url += "~$type(${user.id})";
    }
    if (canRequestInvite) {
      url += "~canRequestInvite";
    }
    url += "~region($region)";
    if (["hidden", "friends", "private"].contains(type)) {
      url += "~nonce(${genRandHex(48)})";
    }
    return url;
  }

  launchWorld() {
    List<Widget> children = [];
    getVrchatRegion().forEach((String regionText, String image) => children.add(ListTile(
          leading: region(regionText),
          title: Text(regionText),
          onTap: () => selectWordType(regionText),
        )));

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (BuildContext context) => SingleChildScrollView(
        child: Column(
          children: children,
        ),
      ),
    );
  }

  selectWordType(String regionText) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (BuildContext _) => SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.vrchatPublic),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                genInstanceId(regionText, "public", false).then((instanceId) => lunchWorldModalBottom(context, widget.worldId, instanceId));
              },
            ),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatFriendsPlus),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  genInstanceId(regionText, "hidden", false).then((instanceId) => lunchWorldModalBottom(context, widget.worldId, instanceId));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatFriends),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  genInstanceId(regionText, "friends", false).then((instanceId) => lunchWorldModalBottom(context, widget.worldId, instanceId));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatInvitePlus),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  genInstanceId(regionText, "private", true).then((instanceId) => lunchWorldModalBottom(context, widget.worldId, instanceId));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatInvite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  genInstanceId(regionText, "private", false).then((instanceId) => lunchWorldModalBottom(context, widget.worldId, instanceId));
                })
          ],
        ),
      ),
    );
  }

  _WorldState() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").worlds(widget.worldId).then((VRChatWorld response) {
          setState(
            () {
              column = Column(children: [
                world(context, response),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => VRChatMobileJsonViewer(obj: response.content),
                        ));
                  },
                  child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.grey,
                  ),
                  onPressed: () => launchWorld(),
                  child: Text(AppLocalizations.of(context)!.launchWorld),
                ),
              ]);
            },
          );
          getLoginSession("login_session").then(
            (cookie) {
              VRChatAPI(cookie: cookie ?? "").favoriteGroups("world", offset: 0).then((VRChatFavoriteGroupList response) {
                List<Widget> bottomSheet = [];
                if (response.group.isEmpty) return;
                bottomSheet.add(ListTile(
                  title: Text(AppLocalizations.of(context)!.addFavoriteWorlds),
                ));
                bottomSheet.add(const Divider());
                for (VRChatFavoriteGroup list in response.group) {
                  bottomSheet.add(ListTile(
                    title: Text(list.displayName),
                    onTap: () => {
                      VRChatAPI(cookie: cookie ?? "").addFavorites("world", widget.worldId, list.name).then((response) {
                        Navigator.pop(context);
                      }).catchError((status) {
                        apiError(context, status);
                      }),
                    },
                  ));
                  bottomSheet.add(const Divider());
                }
                bottomSheet.removeLast();
                setState(
                  () {
                    popupMenu = <Widget>[worldAction(context, widget.worldId, bottomSheet), share(context, "https://vrchat.com/home/world/${widget.worldId}")];
                  },
                );
              }).catchError((status) {
                apiError(context, status);
              });
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world), actions: popupMenu),
      drawer: Navigator.of(context).canPop() ? null : drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 0,
                  right: 30,
                  left: 30,
                ),
                child: column),
          ),
        ),
      ),
    );
  }
}
