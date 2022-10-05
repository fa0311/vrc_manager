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
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/user.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:vrchat_mobile_client/widgets/modal.dart';
import 'package:vrchat_mobile_client/widgets/profile.dart';
import 'package:vrchat_mobile_client/widgets/template.dart';

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
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: widget.appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = widget.appConfig.gridConfigList.searcUsers;
  GridModalConfig gridConfig = GridModalConfig();
  List<VRChatLimitedWorld> worldList = [];
  Map<String, VRChatWorld?> locationMap = {};
  List<VRChatUser> userList = [];
  TextEditingController searchBoxController = TextEditingController();
  FocusNode searchBoxFocusNode = FocusNode();
  String? text;
  SearchMode searchingMode = SearchMode.users;
  SearchMode searchModeSelected = SearchMode.users;

  @override
  initState() {
    super.initState();
    gridConfig.joinable = true;
    gridConfig.worldDetails = true;
    gridConfig.url = "https://vrchat.com/home/search/$text";
    gridConfig.sort?.frendsInInstance = true;
  }

  GridView extractionUserDefault() {
    return renderGrid(
      context,
      width: 600,
      height: config.worldDetails ? 235 : 130,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return genericTemplate(
              context,
              appConfig,
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              children: [
                username(user),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                  if (!["private", "offline", "traveling"].contains(user.location)) locationMap[worldId]!.name,
                  if (user.location == "private") AppLocalizations.of(context)!.privateWorld,
                  if (user.location == "traveling") AppLocalizations.of(context)!.traveling,
                ].whereType<String>()) ...[
                  Text(text, style: const TextStyle(fontSize: 15)),
                ],
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  GridView extractionUserSimple() {
    return renderGrid(
      context,
      width: 320,
      height: config.worldDetails ? 119 : 64,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            return genericTemplate(
              context,
              appConfig,
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              children: [
                username(user, diameter: 12),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                ].whereType<String>()) ...[
                  Text(text, style: const TextStyle(fontSize: 10)),
                ],
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  GridView extractionUserText() {
    return renderGrid(
      context,
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatUser user in userList)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            return genericTemplateText(
              context,
              appConfig,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(appConfig, userId: user.id),
                  )),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    username(user, diameter: 15),
                    if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
  }

  GridView extractionWorldDefault() {
    return renderGrid(
      context,
      width: 600,
      height: 130,
      children: [
        for (VRChatLimitedWorld world in worldList)
          () {
            return genericTemplate(
              context,
              widget.appConfig,
              imageUrl: world.thumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
                  )),
              children: [
                SizedBox(
                  child: Text(
                    world.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1,
                    ),
                  ),
                ),
              ],
            );
          }(),
      ],
    );
  }

  GridView extractionWorldSimple() {
    return renderGrid(
      context,
      width: 320,
      height: 64,
      children: [
        for (VRChatLimitedWorld world in worldList)
          () {
            return genericTemplate(
              context,
              widget.appConfig,
              imageUrl: world.thumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
                  )),
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    world.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ),
              ],
            );
          }(),
      ],
    );
  }

  GridView extractionWoldrText() {
    return renderGrid(
      context,
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatLimitedWorld world in worldList)
          () {
            return genericTemplateText(
              context,
              appConfig,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
                  )),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(world.name, style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            );
          }(),
      ].whereType<Widget>().toList(),
    );
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

  Future get() async {
    int len;
    searchBoxFocusNode.unfocus();
    if (searchingMode == SearchMode.worlds) {
      do {
        int offset = worldList.length;
        List<VRChatLimitedWorld> worlds = await vrhatLoginSession.searchWorlds(text ?? "", offset: offset).catchError((status) {
          apiError(context, widget.appConfig, status);
        });
        worldList.addAll(worlds);
        len = worlds.length;
      } while (len == 50 && worldList.length % 50 != 0);
    } else if (searchingMode == SearchMode.users) {
      do {
        int offset = userList.length;
        List<VRChatUser> users = await vrhatLoginSession.searchUsers(text ?? "", offset: offset).catchError((status) {
          apiError(context, widget.appConfig, status);
        });
        userList.addAll(users);
        len = users.length;
      } while (len == 50 && userList.length % 50 != 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
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
                  if (config.displayMode == "normal") extractionUserDefault(),
                  if (config.displayMode == "simple") extractionUserSimple(),
                  if (config.displayMode == "text_only") extractionUserText(),
                ],
                if (worldList.isNotEmpty) ...[
                  if (config.displayMode == "normal") extractionWorldDefault(),
                  if (config.displayMode == "simple") extractionWorldSimple(),
                  if (config.displayMode == "text_only") extractionWoldrText(),
                ],
                /*
                if (dataColumnWorlds.worldList.length == offset && offset > 0)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.readMore),
                          onPressed: () => moreOver(searchBoxController.text).then(
                            (_) => setState(
                              () => body = dataColumnWorlds.render(children: dataColumnWorlds.reload()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
