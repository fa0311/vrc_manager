// Project imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum GridModalConfigType {
  onlineFriends,
  offlineFriends,
  friendsRequest,
  searchUsers,
  searchWorlds,
  favoriteWorlds;
}

enum SortMode {
  normal,
  name,
  lastLogin,
  friendsInInstance,
  updatedDate,
  labsPublicationDate,
  heat,
  capacity,
  occupants;

  String toLocalization(BuildContext context) {
    switch (this) {
      case SortMode.normal:
        return AppLocalizations.of(context)!.sortedByDefault;
      case SortMode.name:
        return AppLocalizations.of(context)!.sortedByName;
      case SortMode.lastLogin:
        return AppLocalizations.of(context)!.sortedByLastLogin;
      case SortMode.friendsInInstance:
        return AppLocalizations.of(context)!.sortedByFriendsInInstance;
      case SortMode.updatedDate:
        return AppLocalizations.of(context)!.sortedByUpdatedDate;
      case SortMode.labsPublicationDate:
        return AppLocalizations.of(context)!.sortedByLabsPublicationDate;
      case SortMode.heat:
        return AppLocalizations.of(context)!.sortedByHeat;
      case SortMode.capacity:
        return AppLocalizations.of(context)!.sortedByCapacity;
      case SortMode.occupants:
        return AppLocalizations.of(context)!.sortedByOccupants;
    }
  }
}

enum DisplayMode {
  normal,
  simple,
  textOnly;

  String toLocalization(BuildContext context) {
    switch (this) {
      case DisplayMode.normal:
        return AppLocalizations.of(context)!.normal;
      case DisplayMode.simple:
        return AppLocalizations.of(context)!.simple;
      case DisplayMode.textOnly:
        return AppLocalizations.of(context)!.textOnly;
    }
  }
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
