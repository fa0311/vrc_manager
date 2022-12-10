// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
