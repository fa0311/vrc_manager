// Flutter imports:

// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/config.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/widgets/modal/user.dart';
import 'package:vrc_manager/widgets/user.dart';

class UserModal extends ConsumerWidget {
  final VRChatUser user;
  final VRChatFriendStatus status;
  final WorldModalType type;

  const UserModal({
    super.key,
    required this.user,
    required this.status,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.editNote),
          onTap: () {
            showDialog(context: context, builder: (context) => editNote(user));
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.editBio),
          onTap: () {
            showDialog(context: context, builder: (context) => editBio(user));
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.friendManagement),
          onTap: () {
            showModalBottomSheetConsumer(
              context: context,
              builder: (BuildContext context, WidgetRef ref, Widget? child) => Column(
                children: profileAction(context, status, user),
              ),
            );
          },
        )
      ],
    );
  }
}
