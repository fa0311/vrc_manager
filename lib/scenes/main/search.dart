// Flutter imports:

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
import 'package:vrc_manager/assets/sort/worlds_favorite.dart';
import 'package:vrc_manager/assets/storage.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/world.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatSearch extends StatefulWidget {
  final AppConfig appConfig;

  const VRChatSearch(this.appConfig, {Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

enum SearchMode {
  users,
  worlds,
}

class _SearchState extends State<VRChatSearch> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.appConfig.gridConfigList.searchUsers;
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatLimitedWorld> worldList = [];
  Map<String, VRChatWorld?> locationMap = {};
  List<VRChatUser> userList = [];
  TextEditingController searchBoxController = TextEditingController();
  FocusNode searchBoxFocusNode = FocusNode();
  String? text;
  SearchMode searchingMode = SearchMode.users;
  SearchMode searchModeSelected = SearchMode.users;
  String sortedModeCache = "default";
  bool sortedDescendCache = false;

  @override
  initState() {
    super.initState();
    init();
  }

  void init() {
    sortedModeCache = "default";
    sortedDescendCache = false;
    gridConfig = GridModalConfig();
    gridConfig.url = "https://vrchat.com/home/search/$text";
    if (searchingMode == SearchMode.worlds) {
      gridConfig.sort?.updatedDate = true;
      gridConfig.sort?.labsPublicationDate = true;
      gridConfig.sort?.heat = true;
      gridConfig.sort?.capacity = true;
      gridConfig.sort?.occupants = true;
    }
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
                trailing: searchModeSelected == SearchMode.users ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchModeSelected = SearchMode.users);
                  setStateBuilderParent(() {});
                  setStorage("search_mode", searchModeSelected.name);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.world),
                trailing: searchModeSelected == SearchMode.worlds ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchModeSelected = SearchMode.worlds);
                  setStateBuilderParent(() {});
                  setStorage("search_mode", searchModeSelected.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addWorldList(VRChatLimitedWorld world) {
    for (VRChatLimitedWorld worldValue in worldList) {
      if (world.id == worldValue.id) {
        return;
      }
    }
    worldList.add(world);
  }

  Future get() async {
    int len;
    searchBoxFocusNode.unfocus();
    if (searchingMode == SearchMode.users) {
      do {
        int offset = userList.length;
        List<VRChatUser> users = await vrchatLoginSession.searchUsers(text ?? "", offset: offset).catchError((status) {
          apiError(context, widget.appConfig, status);
        });
        for (VRChatUser user in users) {
          userList.add(user);
        }
        len = users.length;
      } while (len == 50 && userList.length < 200);
    } else if (searchingMode == SearchMode.worlds) {
      do {
        int offset = worldList.length;
        List<VRChatLimitedWorld> worlds = await vrchatLoginSession.searchWorlds(text ?? "", offset: offset).catchError((status) {
          apiError(context, widget.appConfig, status);
        });
        for (VRChatLimitedWorld world in worlds) {
          addWorldList(world);
        }
        len = worlds.length;
      } while (len == 50 && worldList.length < 200);
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    if (worldList.isNotEmpty && config.sort != sortedModeCache) {
      sortWorlds(config, worldList);
      sortedModeCache = config.sort;
    }
    if (worldList.isNotEmpty && config.descending != sortedDescendCache) {
      worldList.reversed.toList();
      sortedDescendCache = config.descending;
    }
    if (userList.isNotEmpty && config.sort != sortedModeCache) {
      sortUsers(config, userList);
      sortedModeCache = config.sort;
    }
    if (userList.isNotEmpty && config.descending != sortedDescendCache) {
      userList.reversed.toList();
      sortedDescendCache = config.descending;
    }

    const selectedTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
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
                          searchingMode = searchModeSelected;
                          text = searchBoxController.text;
                          worldList = [];
                          userList = [];
                          setState(() {});
                          get().then((value) => setState(() {}));
                          init();
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
                              SearchMode.users: Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                              SearchMode.worlds: Text(AppLocalizations.of(context)!.world, style: selectedTextStyle),
                            }[searchModeSelected] ??
                            Text(AppLocalizations.of(context)!.user, style: selectedTextStyle),
                        onTap: () => setState(() => searchModeModal(setState)),
                      ),
                    ],
                  ),
                ),
                if (userList.isEmpty && worldList.isEmpty && text != null) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                if (userList.isNotEmpty) ...[
                  if (config.displayMode == "normal") extractionUserDefault(context, config, userList),
                  if (config.displayMode == "simple") extractionUserSimple(context, config, userList),
                  if (config.displayMode == "text_only") extractionUserText(context, config, userList),
                ],
                if (worldList.isNotEmpty) ...[
                  if (config.displayMode == "normal") extractionWorldDefault(context, config, worldList),
                  if (config.displayMode == "simple") extractionWorldSimple(context, config, worldList),
                  if (config.displayMode == "text_only") extractionWorldText(context, config, worldList),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
