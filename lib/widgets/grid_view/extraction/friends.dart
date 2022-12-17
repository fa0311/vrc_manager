// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/sort/users.dart';
import 'package:vrc_manager/scenes/sub/user.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/consumer.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/modal/world.dart';
import 'package:vrc_manager/widgets/user.dart';
import 'package:vrc_manager/widgets/world.dart';

class ExtractionFriend extends ConsumerGridWidget {
  final List<VRChatFriends> userList;
  final Map<String, VRChatWorld?> locationMap;
  final Map<String, VRChatInstance?> instanceMap;

  const ExtractionFriend({
    super.key,
    required super.id,
    required this.userList,
    required this.locationMap,
    required this.instanceMap,
  });

  @override
  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 600,
      height: config.worldDetails ? 235 : 130,
      children: [
        for (VRChatFriends user in sortUsers(config, userList) as List<VRChatFriends>)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return GenericTemplate(
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () {
                    return Column(children: userDetailsModalBottom(user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false)));
                  },
                );
              },
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == "private") return privateWorld(context, card: false);
                if (user.location == "traveling") return privateWorld(context, card: false);
                if (user.location == "offline") return const OnTheWebsite();
                if (locationMap[worldId] == null) return null;
                return instanceWidget(context, locationMap[worldId]!, instanceMap[user.location]!, card: false);
              }(),
              children: [
                username(user),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                  if (!["private", "offline", "traveling"].contains(user.location)) locationMap[worldId]?.name,
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

  @override
  Widget simple(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 320,
      height: config.worldDetails ? 119 : 64,
      children: [
        for (VRChatFriends user in sortUsers(config, userList) as List<VRChatFriends>)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return GenericTemplate(
              imageUrl: user.profilePicOverride ?? user.currentAvatarThumbnailImageUrl,
              half: true,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () {
                    return Column(children: userDetailsModalBottom(user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false)));
                  },
                );
              },
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == "private") return privateWorld(context, card: false, half: true);
                if (user.location == "traveling") return privateWorld(context, card: false, half: true);
                if (user.location == "offline") return const OnTheWebsite(half: true);
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

  @override
  Widget textOnly(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 400,
      height: config.worldDetails ? 39 : 26,
      children: [
        for (VRChatFriends user in sortUsers(config, userList) as List<VRChatFriends>)
          () {
            if (["private", "offline", "traveling"].contains(user.location) && config.joinable) return null;
            String worldId = user.location.split(":")[0];
            return GenericTemplateText(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileUser(userId: user.id),
                  )),
              onLongPress: () {
                showModalBottomSheetStatelessWidget(
                  context: context,
                  builder: () {
                    return Column(children: [
                      if (config.worldDetails &&
                          !["private", "offline", "traveling"].contains(user.location) &&
                          locationMap[worldId] != null &&
                          instanceMap[user.location] != null)
                        ...userInstanceDetailsModalBottom(user, locationMap[worldId]!, instanceMap[user.location]!)
                      else
                        ...userDetailsModalBottom(user, VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false))
                    ]);
                  },
                );
              },
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
}
