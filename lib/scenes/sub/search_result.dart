// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/search.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/world.dart';

final vrchatMobileSearchModeProvider = StateProvider<SearchMode>((ref) => SearchMode.users);

final vrchatMobileSearchProvider = FutureProvider.family<VRChatMobileSearchData, VRChatMobileSearchArgs>((ref, args) async {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  List<VRChatUser> userList = [];
  List<VRChatLimitedWorld> worldList = [];
  int len;

  addWorldList(VRChatLimitedWorld world) {
    for (VRChatLimitedWorld worldValue in worldList) {
      if (world.id == worldValue.id) {
        return;
      }
    }
    worldList.add(world);
  }

  switch (args.searchingMode) {
    case SearchMode.users:
      do {
        int offset = userList.length;
        List<VRChatUser> users = await vrchatLoginSession.searchUsers(args.text, offset: offset);
        for (VRChatUser user in users) {
          userList.add(user);
        }
        len = users.length;
      } while (len == 50 && userList.length < 200);
      break;
    case SearchMode.worlds:
      do {
        int offset = worldList.length;
        List<VRChatLimitedWorld> worlds = await vrchatLoginSession.searchWorlds(args.text, offset: offset);
        for (VRChatLimitedWorld world in worlds) {
          addWorldList(world);
        }
        len = worlds.length;
      } while (len == 50 && worldList.length < 200);
      break;
  }

  return VRChatMobileSearchData(userList: userList, worldList: worldList);
});

class VRChatMobileSearchResult extends ConsumerWidget {
  final VRChatMobileSearchArgs args;
  const VRChatMobileSearchResult({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    searchModeModal() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (context, ref, child) {
            SearchMode searchMode = ref.watch(vrchatMobileSearchModeProvider);
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.user),
                    trailing: searchMode == SearchMode.users ? const Icon(Icons.check) : null,
                    onTap: () {
                      ref.read(vrchatMobileSearchModeProvider.notifier).state = SearchMode.users;
                    },
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.world),
                    trailing: searchMode == SearchMode.worlds ? const Icon(Icons.check) : null,
                    onTap: () {
                      ref.read(vrchatMobileSearchModeProvider.notifier).state = SearchMode.worlds;
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    late GridConfig config = appConfig.gridConfigList.searchUsers;
    late SortData sortData = SortData(config);
    TextEditingController searchBoxController = TextEditingController()..text = args.text;
    AsyncValue<VRChatMobileSearchData> data = ref.watch(vrchatMobileSearchProvider(args));

    textStream(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
              child: TextField(
                controller: searchBoxController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.search,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => VRChatMobileSearchResult(
                          args: VRChatMobileSearchArgs(
                            text: searchBoxController.text,
                            searchingMode: ref.read(vrchatMobileSearchModeProvider),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                SearchMode searchMode = ref.watch(vrchatMobileSearchModeProvider);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.type),
                        trailing: Text(searchMode.toLocalization(context),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            )),
                        onTap: () => searchModeModal(),
                      ),
                    ],
                  ),
                );
              },
            ),
            Consumer(builder: (context, ref, child) {
              return data.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
                data: (VRChatMobileSearchData data) {
                  List<VRChatUser> userList = data.userList;
                  List<VRChatLimitedWorld> worldList = data.worldList;
                  if (userList.isNotEmpty) {
                    userList = sortData.users(userList);
                    switch (config.displayMode) {
                      case DisplayMode.normal:
                        return extractionUserDefault(context, config, userList);
                      case DisplayMode.simple:
                        return extractionUserSimple(context, config, userList);
                      case DisplayMode.textOnly:
                        return extractionUserText(context, config, userList);
                    }
                  }
                  if (worldList.isNotEmpty) {
                    worldList = sortData.worlds(worldList);
                    switch (config.displayMode) {
                      case DisplayMode.normal:
                        return extractionWorldDefault(context, config, worldList);
                      case DisplayMode.simple:
                        return extractionWorldSimple(context, config, worldList);
                      case DisplayMode.textOnly:
                        return extractionWorldText(context, config, worldList);
                    }
                  }
                  return Column(children: const []);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
