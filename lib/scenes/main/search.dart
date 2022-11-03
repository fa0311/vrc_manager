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
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/world.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatSearch extends StatefulWidget {
  const VRChatSearch({Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

class _SearchState extends State<VRChatSearch> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = appConfig.gridConfigList.searchUsers;
  late SortData sortData = SortData(config);
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatLimitedWorld> worldList = [];
  Map<String, VRChatWorld?> locationMap = {};
  List<VRChatUser> userList = [];
  FocusNode searchBoxFocusNode = FocusNode();
  String? text;
  SearchMode searchingMode = SearchMode.users;
  SearchMode searchModeSelected = SearchMode.users;
  TextEditingController searchBoxController = TextEditingController();
  bool loadingComplete = true;

  @override
  initState() {
    super.initState();
    init();
  }

  void init() {
    gridConfig = GridModalConfig();
    gridConfig.url = "https://vrchat.com/home/search/$text";
    gridConfig.displayMode = [
      DisplayMode.normal,
      DisplayMode.simple,
      DisplayMode.textOnly,
    ];
    switch (searchingMode) {
      case SearchMode.users:
        gridConfig.sortMode = [
          SortMode.normal,
          SortMode.name,
        ];
        config = appConfig.gridConfigList.searchWorlds;
        sortData = SortData(config);
        break;
      case SearchMode.worlds:
        gridConfig.sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.updatedDate,
          SortMode.labsPublicationDate,
          SortMode.heat,
          SortMode.capacity,
          SortMode.occupants,
        ];
        config = appConfig.gridConfigList.searchUsers;
        sortData = SortData(config);
        break;
    }
  }

  searchModeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setState) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.user),
                trailing: searchModeSelected == SearchMode.users ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() => searchModeSelected = SearchMode.users);
                  setState(() {});
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.world),
                trailing: searchModeSelected == SearchMode.worlds ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() => searchModeSelected = SearchMode.worlds);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  addWorldList(VRChatLimitedWorld world) {
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
          apiError(context, status);
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
          apiError(context, status);
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
    textStream(context);
    if (userList.isNotEmpty && loadingComplete) {
      userList = sortData.users(userList);
    }
    if (worldList.isNotEmpty && loadingComplete) {
      worldList = sortData.worlds(worldList);
    }
    const selectedTextStyle = TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );
    return SingleChildScrollView(
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
                    init();
                    setState(() => loadingComplete = false);
                    get().then((value) => setState(() => loadingComplete = true));
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
                  trailing: Text(searchModeSelected.toLocalization(context), style: selectedTextStyle),
                  onTap: () => searchModeModal(),
                ),
              ],
            ),
          ),
          if (!loadingComplete) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
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
          if (worldList.isNotEmpty)
            () {
              switch (config.displayMode) {
                case DisplayMode.normal:
                  return extractionWorldDefault(context, config, worldList);
                case DisplayMode.simple:
                  return extractionWorldSimple(context, config, worldList);
                case DisplayMode.textOnly:
                  return extractionWorldText(context, config, worldList);
              }
            }(),
        ],
      ),
    );
  }
}
