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
import 'package:vrchat_mobile_client/widgets/share.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';

class VRChatMobileFriendRequest extends StatefulWidget {
  const VRChatMobileFriendRequest({Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriendRequest> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<VRChatMobileFriendRequest> {
  int offset = 0;
  List<Widget> children = [];

  late Column column = Column(
    children: const [
      Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
    ],
  );

  Users dataColumn = Users();
  _FriendRequestPageState() {
    moreOver();
  }
  moreOver() {
    getLoginSession("login_session").then(
      (cookie) {
        VRChatAPI(cookie: cookie ?? "").notifications(type: "friendRequest", offset: offset).then((VRChatNotificationsList response) {
          offset += 100;
          if (response.notifications.isEmpty && dataColumn.children.isEmpty) {
            setState(
              () => column = Column(
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.none),
                ],
              ),
            );
          }
          for (VRChatNotifications requestUser in response.notifications) {
            VRChatAPI(cookie: cookie ?? "").users(requestUser.senderUserId).then((VRChatUser user) {
              setState(
                () => column = Column(
                  children: dataColumn.add(user),
                ),
              );
            }).catchError((status) {
              apiError(context, status);
            });
          }
        }).catchError((status) {
          apiError(context, status);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dataColumn.context = context;
    getStorage("auto_read_more").then(
      (response) {
        if (dataColumn.children.length == offset && offset > 0 && response == "true") moreOver();
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.friendRequest),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.openInBrowser),
                        onTap: () {
                          Navigator.pop(context);
                          openInBrowser(context, "https://vrchat.com/home/messages");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                column,
                if (dataColumn.children.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
