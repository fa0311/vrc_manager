// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/api/enum/instance_type.dart';

String vrchatInstanceTypeToLocalization(VRChatInstanceType type, BuildContext context) {
  switch (type) {
    case VRChatInstanceType.public:
      return AppLocalizations.of(context)!.vrchatPublic;
    case VRChatInstanceType.hidden:
      return AppLocalizations.of(context)!.vrchatFriendsPlus;
    case VRChatInstanceType.friends:
      return AppLocalizations.of(context)!.vrchatFriends;
  }
}
