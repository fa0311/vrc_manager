// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Map<String, String> getVrchatInstanceType(context) {
  return {
    "public": AppLocalizations.of(context)!.vrchatPublic,
    "hidden": AppLocalizations.of(context)!.vrchatFriendsPlus,
    "friends": AppLocalizations.of(context)!.vrchatFriends,
  };
}
