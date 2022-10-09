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
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileFriendRequest extends StatefulWidget {
  final AppConfig appConfig;

  const VRChatMobileFriendRequest(this.appConfig, {Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriendRequest> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriendRequest> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.appConfig.gridConfigList.friendsRequest;
  List<VRChatUser> userList = [];
  Widget body = const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());

  @override
  initState() {
    super.initState();
    get().then((value) => null);
  }

  Future get() async {
    int offset = 0;
    List<Future> futureList = [];
    do {
      List<VRChatNotifications> response = await vrchatLoginSession.notifications(type: "friendRequest", offset: offset).catchError((status) {
        apiError(context, widget.appConfig, status);
      });
      for (VRChatNotifications requestUser in response) {
        futureList.add(vrchatLoginSession.users(requestUser.senderUserId).then((VRChatUser user) {
          userList.add(user);
        }).catchError((status) {
          apiError(context, widget.appConfig, status);
        }));
      }
      offset += 50;
    } while (userList.length % 50 == 0);
    return Future.wait(futureList);
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    GridModalConfig gridConfig = GridModalConfig();

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
            child: body,
          ),
        ),
      ),
    );
  }
}
