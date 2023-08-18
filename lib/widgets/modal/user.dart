// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/future/button.dart';
import 'package:vrc_manager/widgets/future/tile.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/user.dart';

class SelfUserModalBottom extends ConsumerWidget {
  final VRChatUserSelf user;
  const SelfUserModalBottom({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EditBioTileWidget(user: user),
          EditNoteTileWidget(user: user),
          ShareUrlTileWidget(url: VRChatAssets.user.resolve(user.id)),
          OpenInJsonViewer(content: user.content),
        ],
      ),
    );
  }
}

class UserDetailsModalBottom extends ConsumerWidget {
  final VRChatUser user;
  final VRChatFriendStatus status;
  const UserDetailsModalBottom({super.key, required this.user, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EditNoteTileWidget(user: user),
          ProfileActionTileWidget(status: status, user: user),
          ShareUrlTileWidget(url: VRChatAssets.user.resolve(user.id)),
          OpenInJsonViewer(content: user.content),
        ],
      ),
    );
  }
}

class EditNoteTileWidget extends ConsumerWidget {
  final VRChatUser user;
  const EditNoteTileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.editNote),
      onTap: () {
        showDialog(context: context, builder: (context) => EditNote(user: user));
      },
    );
  }
}

class EditBioTileWidget extends ConsumerWidget {
  final VRChatUser user;
  const EditBioTileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.editBio),
      onTap: () {
        showDialog(context: context, builder: (context) => EditBio(user: user));
      },
    );
  }
}

class ProfileActionTileWidget extends ConsumerWidget {
  final VRChatFriendStatus status;
  final VRChatUser user;
  const ProfileActionTileWidget({super.key, required this.status, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.friendManagement),
      onTap: () {
        showModalBottomSheetStatelessWidget(
          context: context,
          builder: () => ProfileAction(status: status, user: user),
        );
      },
    );
  }
}

class ProfileAction extends ConsumerWidget {
  final VRChatFriendStatus status;
  final VRChatUser user;

  const ProfileAction({super.key, required this.status, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatAPI vrchatLoginSession = VRChatAPI(
      cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "",
      userAgent: ref.watch(accountConfigProvider).userAgent,
      logger: logger,
    );

    Future sendFriendRequest() async {
      await vrchatLoginSession.sendFriendRequest(user.id).then((value) {
        Navigator.of(context).pop();
      }).catchError((e, trace) {
        logger.e(getMessage(e), error: e, stackTrace: trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      status.outgoingRequest = true;
    }

    Future acceptFriendRequest() async {
      await vrchatLoginSession.acceptFriendRequestByUid(user.id).then((value) {
        Navigator.of(context).pop();
      }).catchError((e, trace) {
        logger.e(getMessage(e), error: e, stackTrace: trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      status.isFriend = true;
      status.incomingRequest = false;
    }

    Future deleteFriendRequest() async {
      await vrchatLoginSession.deleteFriendRequest(user.id).then((value) {
        Navigator.of(context).pop();
      }).catchError((e, trace) {
        logger.e(getMessage(e), error: e, stackTrace: trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      status.outgoingRequest = false;
    }

    deleteFriend() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.unfriendConfirm,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FutureButton(
                onPressed: () async {
                  await vrchatLoginSession.deleteFriend(user.id).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }).catchError((e, trace) {
                    logger.e(getMessage(e), error: e, stackTrace: trace);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                  status.isFriend = false;
                },
                child: Text(AppLocalizations.of(context)!.unfriend),
              ),
            ],
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (!status.isFriend && !status.incomingRequest && !status.outgoingRequest)
            FutureTile(
              leading: const Icon(Icons.person_add),
              title: Text(AppLocalizations.of(context)!.friendRequest),
              onTap: sendFriendRequest,
            ),
          if (status.isFriend && !status.incomingRequest && !status.outgoingRequest)
            ListTile(
              leading: const Icon(Icons.person_remove),
              title: Text(AppLocalizations.of(context)!.unfriend),
              onTap: deleteFriend,
            ),
          if (!status.isFriend && status.outgoingRequest)
            FutureTile(
              leading: const Icon(Icons.person_remove),
              title: Text(AppLocalizations.of(context)!.requestCancel),
              onTap: deleteFriendRequest,
            ),
          if (!status.isFriend && status.incomingRequest)
            FutureTile(
              leading: const Icon(Icons.person_add),
              title: Text(AppLocalizations.of(context)!.allowFriends),
              onTap: acceptFriendRequest,
            ),
          if (!status.isFriend && status.incomingRequest)
            FutureTile(
              leading: const Icon(Icons.person_remove),
              title: Text(AppLocalizations.of(context)!.denyFriends),
              onTap: deleteFriendRequest,
            ),
        ],
      ),
    );
  }
}
