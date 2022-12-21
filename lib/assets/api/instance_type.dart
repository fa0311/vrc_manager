// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
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
