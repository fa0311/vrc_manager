// Flutter imports:
import 'package:flutter/material.dart';
import 'package:vrc_manager/widgets/modal.dart';

Future modalBottom(BuildContext context, List<Widget> children) {
  return showModalBottomSheetConsumerWidget(
    context: context,
    builder: () => SingleChildScrollView(
      child: Column(
        children: children,
      ),
    ),
  );
}
