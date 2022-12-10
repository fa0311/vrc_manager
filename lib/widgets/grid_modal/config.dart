// Project imports:
import 'package:vrc_manager/data_class/modal.dart';

enum GridModalConfigType {
  onlineFriends,
  offlineFriends,
  friendsRequest,
  searchUsers,
  searchWorlds,
  favoriteWorlds;
}

class GridModalConfigData {
  List<SortMode> sortMode = [];
  List<DisplayMode> displayMode = [];
  bool worldDetails = false;
  bool joinable = false;
  bool removeButton = false;
  Uri? url;
}

GridModalConfigData getGridModalConfig({
  required GridModalConfigType type,
  required String text,
}) {
  switch (type) {
    case GridModalConfigType.onlineFriends:
      return GridModalConfigData()
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
    case GridModalConfigType.offlineFriends:
      return GridModalConfigData()
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
    case GridModalConfigType.friendsRequest:
      return GridModalConfigData()
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
    case GridModalConfigType.searchUsers:
      return GridModalConfigData()
        ..url = Uri.https("vrchat.com", "/home/search/$text")
        ..displayMode = [
          DisplayMode.normal,
          DisplayMode.simple,
          DisplayMode.textOnly,
        ]
        ..sortMode = [
          SortMode.normal,
          SortMode.name,
        ];
    case GridModalConfigType.searchWorlds:
      return GridModalConfigData()
        ..url = Uri.https("vrchat.com", "/home/search/$text")
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
    case GridModalConfigType.favoriteWorlds:
      return GridModalConfigData()
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
}
