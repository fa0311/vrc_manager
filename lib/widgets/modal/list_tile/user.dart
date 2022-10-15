// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/dialog.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/user.dart';
import 'package:vrc_manager/widgets/share.dart';

Widget editNoteTileWidget(BuildContext context, Function setState, VRChatUser user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.editNote),
    onTap: () {
      editNote(context, user).then((value) => setState(() {}));
    },
  );
}

Widget editBioTileWidget(BuildContext context, Function setState, VRChatUserSelf user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.editBio),
    onTap: () {
      editBio(context, user).then((value) => setState(() {}));
    },
  );
}

Widget profileActionTileWidget(BuildContext context, Function setState, VRChatFriendStatus status, VRChatUser user) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.friendRequest),
    onTap: () {
      modalBottom(context, profileAction(context, status, user)).then((value) => setState(() {}));
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
      () => vrchatLoginSession.deleteFriend(user.id).then((response) {
        status.isFriend = false;
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((status) {
        apiError(context, status);
      }),
    );
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
