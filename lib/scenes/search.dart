// Flutter imports:

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
import 'package:vrchat_mobile_client/widgets/users.dart';
import 'package:vrchat_mobile_client/widgets/worlds.dart';

class VRChatSearch extends StatefulWidget {
  const VRChatSearch({Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

class _SearchState extends State<VRChatSearch> {
  TextEditingController searchBoxController = TextEditingController();
  FocusNode searchBoxFocusNode = FocusNode();
  String searchMode = "users";
  int offset = 0;
  String? cookie;
  Worlds dataColumnWorlds = Worlds();
  Users dataColumnUsers = Users();
  Widget body = Column(
    children: const [],
  );

  _SearchState() {
    List<Future> futureStorageList = [];
    futureStorageList.add(getLoginSession("login_session").then(
      (response) {
        cookie = response;
      },
    ));
  }

  searchModeModal(Function setStateBuilderParent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.user),
                trailing: searchMode == "users" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchMode = "users");
                  setStateBuilderParent(() {});
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.world),
                trailing: searchMode == "worlds" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchMode = "worlds");
                  setStateBuilderParent(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> moreOver(String text, String searchMode) {
    setState(() {
      offset += 12;
    });
    searchBoxFocusNode.unfocus();
    if (searchMode == "worlds") {
      return VRChatAPI(cookie: cookie ?? "").searchWorlds(text, offset: offset - 12).then((VRChatLimitedWorldList worlds) {
        List<Future> futureList = [];
        for (VRChatLimitedWorld world in worlds.world) {
          futureList.add(VRChatAPI(cookie: cookie ?? "").worlds(world.id).then((VRChatWorld world) {
            dataColumnWorlds.add(world);
          }).catchError((status) {
            apiError(context, status);
          }));
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
          );
        });
      }).catchError((status) {
        apiError(context, status);
      });
    } else if (searchMode == "users") {
      return VRChatAPI(cookie: cookie ?? "").searchUsers(text, offset: offset - 12).then((VRChatUserLimitedList users) {
        List<Future> futureList = [];
        for (VRChatUserLimited user in users.users) {
          futureList.add(VRChatAPI(cookie: cookie ?? "").users(user.id).then((VRChatUser user) {
            dataColumnUsers.userList.add(user);
          }).catchError((status) {
            apiError(context, status);
          }));
        }
        Future.wait(futureList).then((value) {
          setState(
            () => body = dataColumnUsers.render(children: dataColumnUsers.reload()),
          );
        });
      });
    }
    throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    dataColumnUsers.context = context;
    dataColumnWorlds.context = context;

    const selectedTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
                  child: TextField(
                    controller: searchBoxController,
                    focusNode: searchBoxFocusNode,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          body = Column(
                            children: const [
                              Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                            ],
                          );
                          offset = 0;
                          dataColumnWorlds = Worlds();
                          dataColumnUsers = Users();
                          moreOver(searchBoxController.text, searchMode);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.type),
                        trailing: {
                              "users": Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                              "worlds": Text(AppLocalizations.of(context)!.world, style: selectedTextStyle),
                            }[searchMode] ??
                            Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                        onTap: () => setState(() => searchModeModal(setState)),
                      ),
                    ],
                  ),
                ),
                body,
                if (dataColumnUsers.userList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(searchBoxController.text, searchMode).then(
                            (_) => setState(
                              () => body = dataColumnUsers.render(children: dataColumnUsers.reload()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (dataColumnWorlds.worldList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(searchBoxController.text, searchMode).then(
                            (_) => setState(
                              () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
                            ),
                          ),
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
