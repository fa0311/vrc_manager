// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/dialog.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/share.dart';
import 'package:vrc_manager/widgets/user.dart';

List<Widget> selfUserModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatUserSelf user,
) {
  return [
    editBioTileWidget(context, user),
    editNoteTileWidget(context, user),
    shareUrlTileWidget(context, Uri.https("vrchat.com", "/home/user/${user.id}")),
    if (ref.read(debugModeProvider)) openInJsonViewer(context, user.content),
  ];
}

List<Widget> userDetailsModalBottom(
  BuildContext context,
  WidgetRef ref,
  VRChatUser user,
  VRChatFriendStatus status,
) {
  return [
    editNoteTileWidget(context, user),
    shareUrlTileWidget(context, Uri.https("vrchat.com", "/home/user/${user.id}")),
    profileActionTileWidget(context, status, user),
    if (ref.read(debugModeProvider)) openInJsonViewer(context, user.content),
  ];
}

Widget editNoteTileWidget(BuildContext context, VRChatUser user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.editNote),
    onTap: () {
      showDialog(context: context, builder: (context) => editNote(user));
    },
  );
}

Widget editBioTileWidget(BuildContext context, VRChatUserSelf user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.editBio),
    onTap: () {
      showDialog(context: context, builder: (context) => editBio(user));
    },
  );
}

Widget profileActionTileWidget(BuildContext context, VRChatFriendStatus status, VRChatUser user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.friendManagement),
    onTap: () {
      modalBottom(context, profileAction(context, status, user));
    },
  );
}

List<Widget> profileAction(
  BuildContext context,
  VRChatFriendStatus status,
  VRChatUser user,
) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  sendFriendRequest() {
    vrchatLoginSession.sendFriendRequest(user.id).then((VRChatNotifications response) {
      status.outgoingRequest = true;
      Navigator.pop(context);
    }).catchError((status) {
      apiError(context, status);
    });
  }

  acceptFriendRequest() {
    vrchatLoginSession.acceptFriendRequestByUid(user.id).then((VRChatAcceptFriendRequestByUid response) {
      status.isFriend = true;
      status.incomingRequest = false;
      Navigator.pop(context);
    }).catchError((status) {
      apiError(context, status);
    });
  }

  deleteFriendRequest() {
    vrchatLoginSession.deleteFriendRequest(user.id).then((VRChatStatus response) {
      status.outgoingRequest = false;
      Navigator.pop(context);
    }).catchError((status) {
      apiError(context, status);
    });
  }

  deleteFriend() {
    confirm(
      context,
      AppLocalizations.of(context)!.unfriendConfirm,
      AppLocalizations.of(context)!.unfriend,
    ).then((value) {
      if (!value) return;
      vrchatLoginSession.deleteFriend(user.id).then((response) {
        status.isFriend = false;
        Navigator.pop(context);
      }).catchError((status) {
        apiError(context, status);
      });
    });
  }

  return [
    if (!status.isFriend && !status.incomingRequest && !status.outgoingRequest)
      ListTile(
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
      ListTile(
        leading: const Icon(Icons.person_remove),
        title: Text(AppLocalizations.of(context)!.requestCancel),
        onTap: deleteFriendRequest,
      ),
    if (!status.isFriend && status.incomingRequest)
      ListTile(
        leading: const Icon(Icons.person_add),
        title: Text(AppLocalizations.of(context)!.allowFriends),
        onTap: acceptFriendRequest,
      ),
    if (!status.isFriend && status.incomingRequest)
      ListTile(
        leading: const Icon(Icons.person_remove),
        title: Text(AppLocalizations.of(context)!.denyFriends),
        onTap: deleteFriendRequest,
      ),
  ];
}
