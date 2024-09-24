// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Project imports:
import 'package:vrc_manager/api/assets/status.dart';

// Project imports:
class StatusWidget extends ConsumerWidget {
  final VRChatStatusData status;
  final double diameter;
  const StatusWidget({required this.status, this.diameter = 20, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status.toColor(),
      ),
    );
  }
}
