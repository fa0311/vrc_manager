// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/assets/instance_type.dart';
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
  final ScrollPhysics? physics;

  const ExtractionFriend({
    super.key,
    required super.id,
    required this.userList,
    required this.locationMap,
    required this.instanceMap,
    this.physics,
  });

  @override
  Widget normal(BuildContext context, WidgetRef ref, GridConfigNotifier config) {
    return RenderGrid(
      width: 600,
      height: config.worldDetails ? 235 : 130,
      children: [
        for (VRChatFriends user in sortUsers(config, userList) as List<VRChatFriends>)
          () {
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
                  builder: () => UserDetailsModalBottom(user: user, status: VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false)),
                );
              },
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == VRChatInstanceIdOther.private.name) return const PrivateWorld(card: false);
                if (user.location == VRChatInstanceIdOther.traveling.name) return const TravelingWorld(card: false);
                if (user.location == VRChatInstanceIdOther.offline.name) return const OnTheWebsite();
                if (locationMap[worldId] == null) return null;
                return InstanceWidget(world: locationMap[worldId]!, instance: instanceMap[user.location]!, card: false);
              }(),
              children: [
                Username(user: user),
                for (String text in [
                  if (user.statusDescription != null) user.statusDescription!,
                  if (!VRChatInstanceIdOther.values.any((id) => id.name == user.location)) locationMap[worldId]?.name,
                  if (user.location == VRChatInstanceIdOther.private.name) AppLocalizations.of(context)!.privateWorld,
                  if (user.location == VRChatInstanceIdOther.traveling.name) AppLocalizations.of(context)!.traveling,
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
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
                  builder: () => UserDetailsModalBottom(user: user, status: VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false)),
                );
              },
              bottom: () {
                if (!config.worldDetails) return null;
                if (user.location == VRChatInstanceIdOther.private.name) return const PrivateWorld(card: false, half: true);
                if (user.location == VRChatInstanceIdOther.traveling.name) return const TravelingWorld(card: false, half: true);
                if (user.location == VRChatInstanceIdOther.offline.name) return const OnTheWebsite(half: true);
                if (locationMap[worldId] == null) return null;
                return InstanceWidget(world: locationMap[worldId]!, instance: instanceMap[user.location]!, card: false, half: true);
              }(),
              children: [
                Username(user: user, diameter: 12),
                if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
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
            if (config.joinable && VRChatInstanceIdOther.values.any((id) => id.name == user.location)) return null;
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
                    if (config.worldDetails &&
                        !VRChatInstanceIdOther.values.any((id) => id.name == user.location) &&
                        locationMap[worldId] != null &&
                        instanceMap[user.location] != null) {
                      return UserInstanceDetailsModalBottom(user: user, world: locationMap[worldId]!, instance: instanceMap[user.location]!);
                    } else {
                      return UserDetailsModalBottom(user: user, status: VRChatFriendStatus(isFriend: true, incomingRequest: false, outgoingRequest: false));
                    }
                  },
                );
              },
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Username(user: user, diameter: 15),
                    if (user.statusDescription != null) Text(user.statusDescription!, style: const TextStyle(fontSize: 10)),
                  ],
                ),
                if (config.worldDetails)
                  Text(() {
                    if (user.location == VRChatInstanceIdOther.offline.name) return AppLocalizations.of(context)!.privateWorld;
                    if (user.location == VRChatInstanceIdOther.traveling.name) return AppLocalizations.of(context)!.traveling;
                    if (user.location == VRChatInstanceIdOther.offline.name) return AppLocalizations.of(context)!.onTheWebsite;
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
