// Flutter imports:

// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/data_class.dart';

class UserModal extends ConsumerWidget {
  final VRChatUser user;
  final VRChatFriendStatus status;

  const UserModal({
    super.key,
    required this.user,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
