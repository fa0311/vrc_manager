// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/assets/instance_type.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/scenes/sub/world.dart';
import 'package:vrc_manager/widgets/grid_view/template/template.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/world.dart';
import 'package:vrc_manager/widgets/region.dart';

enum VRChatInstanceTypeExt {
  public(type: VRChatInstanceType.public, canRequestInvite: false),
  friendsPlus(type: VRChatInstanceType.hidden, canRequestInvite: false),
  friends(type: VRChatInstanceType.friends, canRequestInvite: false),
  invitePlus(type: VRChatInstanceType.private, canRequestInvite: true),
  invite(type: VRChatInstanceType.private, canRequestInvite: false);

  final VRChatInstanceType type;
  final bool canRequestInvite;

  const VRChatInstanceTypeExt({required this.type, required this.canRequestInvite});

  String toLocalization(BuildContext context) {
    switch (this) {
      case VRChatInstanceTypeExt.public:
        return AppLocalizations.of(context)!.vrchatPublic;
      case VRChatInstanceTypeExt.friendsPlus:
        return AppLocalizations.of(context)!.vrchatFriendsPlus;
      case VRChatInstanceTypeExt.friends:
        return AppLocalizations.of(context)!.vrchatFriends;
      case VRChatInstanceTypeExt.invitePlus:
        return AppLocalizations.of(context)!.vrchatInvitePlus;
      case VRChatInstanceTypeExt.invite:
        return AppLocalizations.of(context)!.vrchatInvite;
    }
  }
}

VRChatInstanceTypeExt toVRChatInstanceTypeExt(VRChatInstanceType type, bool canRequestInvite) {
  switch (type) {
    case VRChatInstanceType.public:
      return VRChatInstanceTypeExt.public;
    case VRChatInstanceType.hidden:
      return VRChatInstanceTypeExt.friendsPlus;
    case VRChatInstanceType.friends:
      return VRChatInstanceTypeExt.friends;
    case VRChatInstanceType.private:
      return canRequestInvite ? VRChatInstanceTypeExt.invitePlus : VRChatInstanceTypeExt.invite;
  }
}

class InstanceWidget extends ConsumerWidget {
  final VRChatWorld world;
  final VRChatInstance instance;
  final bool card;
  final bool half;

  const InstanceWidget({
    super.key,
    required this.world,
    required this.instance,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      imageUrl: world.thumbnailImageUrl,
      card: card,
      half: half,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWorld(worldId: world.id),
        ),
      ),
      onLongPress: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () => InstanceDetailsModalBottom(world: world, instance: instance),
        );
      },
      children: [
        Row(children: <Widget>[
          RegionWidget(region: instance.region, size: half ? 12 : 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(Icons.groups, size: half ? 17 : 25),
                Text(
                  "${instance.nUsers}/${instance.capacity}",
                  style: TextStyle(fontSize: half ? 10 : 15),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                toVRChatInstanceTypeExt(instance.type, instance.canRequestInvite).toLocalization(context),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: half ? 10 : 15,
                ),
              ),
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              world.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: half ? 10 : 15,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PrivateWorld extends ConsumerWidget {
  final bool card;
  final bool half;

  const PrivateWorld({
    super.key,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      card: card,
      half: half,
      imageUrl: VRChatAssets.defaultPrivateImage.toString(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context)!.privateWorld,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: half ? 10 : 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TravelingWorld extends ConsumerWidget {
  final bool card;
  final bool half;

  const TravelingWorld({
    super.key,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GenericTemplate(
      card: card,
      half: half,
      imageUrl: VRChatAssets.defaultBetweenImage.toString(),
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context)!.loadingWorld,
            style: TextStyle(fontSize: half ? 10 : 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context)!.privateWorld,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: half ? 10 : 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
