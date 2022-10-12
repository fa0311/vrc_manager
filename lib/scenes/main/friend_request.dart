// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatMobileFriendRequest extends StatefulWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriendRequest> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriendRequest> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = appConfig.gridConfigList.friendsRequest;
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatUser> userList = [];
  SortMode sortedModeCache = SortMode.normal;
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    gridConfig.sortMode = [
      SortMode.normal,
      SortMode.name,
    ];
    gridConfig.displayMode = [
      DisplayMode.normal,
      DisplayMode.simple,
      DisplayMode.textOnly,
    ];
    get().then((value) => setState(() {}));
  }

  Future get() async {
    List<Future> futureList = [];
    int len;
    do {
      int offset = futureList.length;
      List<VRChatNotifications> notify = await vrchatLoginSession.notifications(type: "friendRequest", offset: offset).catchError((status) {
        apiError(context, status);
      });
      for (VRChatNotifications requestUser in notify) {
        futureList.add(vrchatLoginSession.users(requestUser.senderUserId).then((VRChatUser user) {
          userList.add(user);
        }).catchError((status) {
          apiError(context, status);
        }));
      }
      len = notify.length;
    } while (len == 50);
    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    if (config.sortMode != sortedModeCache) {
      sortUsers(config, userList);
      sortedModeCache = config.sortMode;
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
            onPressed: () => gridModal(context, setState, config, gridConfig),
          ),
        ],
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              if (userList.isEmpty) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
              if (userList.isNotEmpty)
                () {
                  switch (config.displayMode) {
                    case DisplayMode.normal:
                      return extractionUserDefault(context, config, userList);
                    case DisplayMode.simple:
                      return extractionUserSimple(context, config, userList);
                    case DisplayMode.textOnly:
                      return extractionUserText(context, config, userList);
                  }
                }(),
            ]),
          ),
        ),
      ),
    );
  }
}
