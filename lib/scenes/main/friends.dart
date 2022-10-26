// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/api/get.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/friends.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;

  const VRChatMobileFriends({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.offline ? appConfig.gridConfigList.offlineFriends : appConfig.gridConfigList.onlineFriends;
  late SortData sortData = SortData(config);
  GridModalConfig gridConfig = GridModalConfig();
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  List<VRChatFriends> userList = [];
  bool loadingComplete = false;

  @override
  initState() {
    super.initState();
    gridConfig.url = "https://vrchat.com/home/locations";
    if (widget.offline) {
      gridConfig.sortMode = [
        SortMode.normal,
        SortMode.name,
        SortMode.lastLogin,
      ];
      gridConfig.displayMode = [
        DisplayMode.normal,
        DisplayMode.simple,
        DisplayMode.textOnly,
      ];
    } else {
      gridConfig.joinable = true;
      gridConfig.worldDetails = true;
      gridConfig.sortMode = [
        SortMode.normal,
        SortMode.name,
        SortMode.friendsInInstance,
        SortMode.lastLogin,
      ];
      gridConfig.displayMode = [
        DisplayMode.normal,
        DisplayMode.simple,
        DisplayMode.textOnly,
      ];
    }
    get().then((value) => setState(() => loadingComplete = true));
  }

  Future get() async {
    List<Future> futureList = [];
    int len;
    do {
      int offset = userList.length;
      List<VRChatFriends> users = await vrchatLoginSession.friends(offline: widget.offline, offset: offset).catchError((status) {
        apiError(context, status);
      });
      if (!mounted) return;
      futureList.add(getWorld(context, users, locationMap));
      futureList.add(getInstance(context, users, instanceMap));
      userList.addAll(users);
      len = users.length;
    } while (len == 50);

    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    if (loadingComplete) {
      userList = sortData.users(userList) as List<VRChatFriends>;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.offline ? AppLocalizations.of(context)!.offlineFriends : AppLocalizations.of(context)!.onlineFriends),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, config, gridConfig).then((value) => setState(() {})),
          ),
        ],
      ),
      drawer: drawer(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              if (!loadingComplete) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              if (userList.isNotEmpty)
                () {
                  switch (config.displayMode) {
                    case DisplayMode.normal:
                      return extractionFriendDefault(context, config, userList, locationMap, instanceMap);
                    case DisplayMode.simple:
                      return extractionFriendSimple(context, config, userList, locationMap, instanceMap);
                    case DisplayMode.textOnly:
                      return extractionFriendText(context, config, userList, locationMap, instanceMap);
                  }
                }(),
            ]),
          ),
        ),
      ),
    );
  }
}
