// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/world.dart';
import 'package:vrc_manager/widgets/modal.dart';

final vrchatMobileSearchModeProvider = StateProvider<SearchMode>((ref) => SearchMode.users);
final vrchatMobileSearchCounterProvider = StateProvider<int>((ref) => 0);
final searchBoxControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ''));

enum SearchMode {
  users,
  worlds;

  String toLocalization(BuildContext context) {
    switch (this) {
      case SearchMode.users:
        return AppLocalizations.of(context)!.user;
      case SearchMode.worlds:
        return AppLocalizations.of(context)!.world;
    }
  }
}

class VRChatMobileSearchData {
  List<VRChatUser> userList;
  List<VRChatLimitedWorld> worldList;
  late GridConfigNotifier config;
  VRChatMobileSearchData({required this.userList, required this.worldList});
}

final vrchatMobileSearchProvider = FutureProvider<VRChatMobileSearchData>((ref) async {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount!.cookie);
  List<VRChatUser> userList = [];
  List<VRChatLimitedWorld> worldList = [];
  int len;

  ref.watch(vrchatMobileSearchCounterProvider);
  SearchMode searchingMode = ref.watch(vrchatMobileSearchModeProvider);
  String searchingText = ref.read(searchBoxControllerProvider).text;

  addWorldList(VRChatLimitedWorld world) {
    for (VRChatLimitedWorld worldValue in worldList) {
      if (world.id == worldValue.id) {
        return;
      }
    }
    worldList.add(world);
  }

  switch (searchingMode) {
    case SearchMode.users:
      do {
        int offset = userList.length;
        List<VRChatUser> users = await vrchatLoginSession.searchUsers(searchingText, offset: offset).catchError((e) {
          logger.e(e);
        });
        for (VRChatUser user in users) {
          userList.add(user);
        }
        len = users.length;
      } while (len == 50 && userList.length < 200);
      break;
    case SearchMode.worlds:
      do {
        int offset = worldList.length;
        List<VRChatLimitedWorld> worlds = await vrchatLoginSession.searchWorlds(searchingText, offset: offset).catchError((e) {
          logger.e(e);
        });
        for (VRChatLimitedWorld world in worlds) {
          addWorldList(world);
        }
        len = worlds.length;
      } while (len == 50 && worldList.length < 200);
      break;
  }

  return VRChatMobileSearchData(userList: userList, worldList: worldList);
});

class VRChatMobileSearch extends ConsumerWidget {
  const VRChatMobileSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int count = ref.watch(vrchatMobileSearchCounterProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vrchatMobileSearchProvider.future),
      notificationPredicate: (notification) => count > 0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
                child: TextField(
                  controller: ref.read(searchBoxControllerProvider),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        FocusScopeNode currentScope = FocusScope.of(context);
                        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        }
                        ref.read(vrchatMobileSearchCounterProvider.notifier).state++;
                      },
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  SearchMode searchMode = ref.watch(vrchatMobileSearchModeProvider);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.type),
                      trailing: Text(
                        searchMode.toLocalization(context),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => showModalBottomSheetConsumer(
                        context: context,
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
                                    ref.read(gridModalConfigIdProvider.notifier).state = GridModalConfigType.searchUsers;
                                  },
                                ),
                                ListTile(
                                  title: Text(AppLocalizations.of(context)!.world),
                                  trailing: searchMode == SearchMode.worlds ? const Icon(Icons.check) : null,
                                  onTap: () {
                                    ref.read(vrchatMobileSearchModeProvider.notifier).state = SearchMode.worlds;
                                    ref.read(gridModalConfigIdProvider.notifier).state = GridModalConfigType.searchWorlds;
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              if (count > 0) const VRChatMobileSearchResult(),
            ],
          ),
        ),
      ),
    );
  }
}

class VRChatMobileSearchResult extends ConsumerWidget {
  const VRChatMobileSearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<VRChatMobileSearchData> data = ref.watch(vrchatMobileSearchProvider);
    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        logger.w(err, err, stack);
        return const ErrorPage();
      },
      data: (VRChatMobileSearchData data) {
        List<VRChatUser> userList = data.userList;
        List<VRChatLimitedWorld> worldList = data.worldList;
        if (userList.isNotEmpty) {
          return ExtractionUser(id: GridModalConfigType.searchUsers, userList: data.userList, status: null);
        }
        if (worldList.isNotEmpty) {
          return ExtractionWorld(id: GridModalConfigType.searchWorlds, worldList: worldList);
        }
        return Container();
      },
    );
  }
}
