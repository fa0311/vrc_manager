// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/user.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/modal/list_tile/world.dart';
import 'package:vrc_manager/widgets/user.dart';
import 'package:vrc_manager/widgets/world.dart';

GridView extractionFriendDefault(
  BuildContext context,
  GridConfig config,
  Function setState,
  List<VRChatFriends> userList,
  Map<String, VRChatWorld?> locationMap,
  Map<String, VRChatInstance?> instanceMap,
) {
  return renderGrid(
    context,
    width: 600,
    height: config.worldDetails ? 235 : 130,
    children: [
      for (VRChatFriends user in userList)
        () {
          if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
          String worldId = user.location.split(":")[0];
          return genericTemplate(
            context,
            imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                )),
            onLongPress: () => modalBottom(
                context, userDetailsModalBottom(context, setState, user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false))),
            bottom: () {
              if (!config.worldDetails) return null;
              if (user.location == "private") return privateWorld(context, card: false);
              if (user.location == "traveling") return privateWorld(context, card: false);
              if (user.location == "offline") return onTheWebsite(context);
              if (locationMap[worldId] == null) return null;
              return instanceWidget(context, locationMap[worldId]!, instanceMap[user.location]!, card: false);
            }(),
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

GridView extractionFriendSimple(
  BuildContext context,
  GridConfig config,
  Function setState,
  List<VRChatFriends> userList,
  Map<String, VRChatWorld?> locationMap,
  Map<String, VRChatInstance?> instanceMap,
) {
  return renderGrid(
    context,
    width: 320,
    height: config.worldDetails ? 119 : 64,
    children: [
      for (VRChatFriends user in userList)
        () {
          if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
          String worldId = user.location.split(":")[0];
          return genericTemplate(
            context,
            imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
            half: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                )),
            onLongPress: () => modalBottom(
                context, userDetailsModalBottom(context, setState, user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false))),
            bottom: () {
              if (!config.worldDetails) return null;
              if (user.location == "private") return privateWorld(context, card: false, half: true);
              if (user.location == "traveling") return privateWorld(context, card: false, half: true);
              if (user.location == "offline") return onTheWebsite(context, half: true);
              if (locationMap[worldId] == null) return null;
              return instanceWidget(context, locationMap[worldId]!, instanceMap[user.location]!, card: false, half: true);
            }(),
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

GridView extractionFriendText(
  BuildContext context,
  GridConfig config,
  Function setState,
  List<VRChatFriends> userList,
  Map<String, VRChatWorld?> locationMap,
  Map<String, VRChatInstance?> instanceMap,
) {
  return renderGrid(
    context,
    width: 400,
    height: config.worldDetails ? 39 : 26,
    children: [
      for (VRChatFriends user in userList)
        () {
          if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
          String worldId = user.location.split(":")[0];
          return genericTemplateText(
            context,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                )),
            onLongPress: () => modalBottom(
              context,
              [
                if (config.worldDetails &&
                    !["private", "offline", "traveling"].contains(user.location) &&
                    locationMap[worldId] != null &&
                    instanceMap[user.location] != null)
                  ...userInstanceDetailsModalBottom(context, setState, user, locationMap[worldId]!, instanceMap[user.location]!)
                else
                  ...userDetailsModalBottom(context, setState, user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false))
              ],
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  username(user, diameter: 15),
                  if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
                ],
              ),
              if (config.worldDetails)
                Text(() {
                  if (user.location == "private") return AppLocalizations.of(context)!.privateWorld;
                  if (user.location == "traveling") return AppLocalizations.of(context)!.traveling;
                  if (user.location == "offline") return AppLocalizations.of(context)!.onTheWebsite;
                  if (locationMap[worldId] == null) return "";
                  return locationMap[worldId]!.name;
                }(), style: const TextStyle(fontSize: 12, height: 1)),
            ],
          );
        }(),
    ].whereType<Widget>().toList(),
  );
}
