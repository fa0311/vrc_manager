// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/date.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/vrchat/region.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/json_viewer.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;
  final AppConfig appConfig;
  const VRChatMobileWorld(this.appConfig, {Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  VRChatWorld? world;

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
    VRChatUserOverload user = await vrhatLoginSession.user().catchError((status) {
      apiError(context, widget.appConfig, status);
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
                genInstanceId(regionText, "public", false)
                    .then((instanceId) => modalBottom(context, shareWorldListTile(context, appConfig, widget.worldId, instanceId)));
              },
            ),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatFriendsPlus),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  genInstanceId(regionText, "hidden", false)
                      .then((instanceId) => modalBottom(context, shareWorldListTile(context, appConfig, widget.worldId, instanceId)));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatFriends),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  genInstanceId(regionText, "friends", false)
                      .then((instanceId) => modalBottom(context, shareWorldListTile(context, appConfig, widget.worldId, instanceId)));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatInvitePlus),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  genInstanceId(regionText, "private", true)
                      .then((instanceId) => modalBottom(context, shareWorldListTile(context, appConfig, widget.worldId, instanceId)));
                }),
            ListTile(
                title: Text(AppLocalizations.of(context)!.vrchatInvite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  genInstanceId(regionText, "private", false)
                      .then((instanceId) => modalBottom(context, shareWorldListTile(context, appConfig, widget.worldId, instanceId)));
                })
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    get().then((value) => setState(() {}));
  }

  Future get() async {
    world = await vrhatLoginSession.worlds(widget.worldId).catchError((status) {
      apiError(context, widget.appConfig, status);
    });
  }

  @override
  Widget build(BuildContext context) {
    textStream(
      context,
      widget.appConfig,
    );
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world), actions: [
        if (world != null) favoriteAction(context, appConfig, world!),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => modalBottom(context, shareUrlListTile(context, widget.appConfig, "https://vrchat.com/home/world/${widget.worldId}")),
        )
      ]),
      drawer: Navigator.of(context).canPop()
          ? null
          : drawer(
              context,
              widget.appConfig,
            ),
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
              child: Column(
                children: [
                  if (world == null) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                  if (world != null) ...[
                    SizedBox(
                      height: 250,
                      child: CachedNetworkImage(
                        imageUrl: world!.imageUrl,
                        fit: BoxFit.fitWidth,
                        progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(
                              strokeWidth: 10,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 250.0,
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(world!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: Text(world!.description ?? ""),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.occupants(
                        world!.occupants,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.privateOccupants(
                        world!.privateOccupants,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.favorites(
                        world!.favorites,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.createdAt(
                        generalDateDifference(context, world!.createdAt),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.updatedAt(
                        generalDateDifference(context, world!.updatedAt),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => VRChatMobileJsonViewer(widget.appConfig, obj: world!.content),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => launchWorld(),
                        child: Text(AppLocalizations.of(context)!.launchWorld),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
