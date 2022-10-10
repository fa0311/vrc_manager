// Dart imports:

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
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/friends.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatMobileFriends extends StatefulWidget {
  final bool offline;
  final AppConfig appConfig;

  const VRChatMobileFriends(this.appConfig, {Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.offline ? widget.appConfig.gridConfigList.offlineFriends : widget.appConfig.gridConfigList.onlineFriends;
  Map<String, VRChatWorld?> locationMap = {};
  Map<String, VRChatInstance?> instanceMap = {};
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatFriends> userList = [];
  String sortedModeCache = "default";
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    gridConfig.joinable = true;
    gridConfig.worldDetails = true;
    gridConfig.url = "https://vrchat.com/home/locations";
    gridConfig.sort?.friendsInInstance = true;
    get().then((value) => setState(() {}));
  }

  Future get() async {
    List<Future> futureList = [];
    int len;
    do {
      int offset = userList.length;
      List<VRChatFriends> users = await vrchatLoginSession.friends(offline: widget.offline, offset: offset).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      if (!mounted) return;
      futureList.add(getWorld(context, appConfig, users, locationMap));
      futureList.add(getInstance(context, appConfig, users, instanceMap));
      userList.addAll(users);
      len = users.length;
    } while (len == 50);

    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    if (config.sort != sortedModeCache) {
      sortUsers(config, userList);
      sortedModeCache = config.sort;
    }
    if (config.descending != sortedDescendCache) {
      userList = userList.reversed.toList();
      sortedDescendCache = config.descending;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friends),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, widget.appConfig, setState, config, gridConfig),
          ),
        ],
      ),
      drawer: drawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              if (userList.isEmpty) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              if (userList.isNotEmpty && config.displayMode == "normal") extractionFriendDefault(context, config, userList, locationMap, instanceMap),
              if (userList.isNotEmpty && config.displayMode == "simple") extractionFriendSimple(context, config, userList, locationMap, instanceMap),
              if (userList.isNotEmpty && config.displayMode == "text_only") extractionFriendText(context, config, userList, locationMap, instanceMap),
            ]),
          ),
        ),
      ),
    );
  }
}
