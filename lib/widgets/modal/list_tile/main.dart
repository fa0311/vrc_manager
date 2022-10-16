// Flutter imports:
import 'package:flutter/material.dart';

Future modalBottom(BuildContext context, List<Widget> children) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Column(
        children: children,
      ),
    ),
  );
}
