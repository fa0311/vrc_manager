// Flutter imports:

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/main/search.dart';

final gridModalProvider = StateProvider<GridModalConfig>((ref) {
  GridConfigId gridConfigId = ref.watch(gridConfigIdProvider);
  ref.watch(vrchatMobileSearchCounterProvider);
  String searchingText = ref.read(searchBoxControllerProvider).text;

  switch (gridConfigId) {
    case GridConfigId.onlineFriends:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/locations")
        ..joinable = true
        ..worldDetails = true
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.friendsInInstance,
          SortMode.lastLogin,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case GridConfigId.offlineFriends:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/locations")
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.lastLogin,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case GridConfigId.friendsRequest:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/messages")
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
        ]
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ];
    case GridConfigId.searchUsers:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/search/$searchingText")
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ]
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
        ];
    case GridConfigId.searchWorlds:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/search/$searchingText")
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ]
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.updatedDate,
          SortMode.labsPublicationDate,
          SortMode.heat,
          SortMode.capacity,
          SortMode.occupants,
        ];
    case GridConfigId.favoriteWorlds:
      return GridModalConfig()
        ..url = Uri.https("vrchat.com", "/home/worlds")
        ..removeButton = true
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ]
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
          SortMode.updatedDate,
          SortMode.labsPublicationDate,
          SortMode.heat,
          SortMode.capacity,
          SortMode.occupants,
        ];
  }
});
