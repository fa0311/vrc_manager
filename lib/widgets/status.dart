// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/api/enum/status.dart';

// Project imports:
class StatusWidget extends ConsumerWidget {
  final VRChatStatusData status;
  final double diameter;
  const StatusWidget({required this.status, this.diameter = 20, Key? key}) : super(key: key);

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
