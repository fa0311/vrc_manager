// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/widgets/world.dart';

class Worlds {
  List<Widget> children = [];
  late BuildContext context;
  List<VRChatLimitedWorld> worldList = [];
  String displayMode = "default";

  List<Widget> reload() {
    children = [];
    List<VRChatLimitedWorld> tempworldList = worldList;
    worldList = [];
    for (VRChatLimitedWorld world in tempworldList) {
      add(world);
    }
    return children;
  }

  List<Widget> add(VRChatLimitedWorld world) {
    worldList.add(world);
    if (displayMode == "default") defaultAdd(world);
    return children;
  }

  defaultAdd(VRChatLimitedWorld world) {
    children.add(simpleWorld(context, world));
  }

  Widget render({required List<Widget> children}) {
    if (children.isEmpty) return Column(children: <Widget>[Text(AppLocalizations.of(context)!.none)]);
    double width = MediaQuery.of(context).size.width;
    int height = 0;
    int wrap = 0;
    if (displayMode == "default") {
      height = 120;
      wrap = 600;
    }

    return GridView.count(
      crossAxisCount: width ~/ wrap + 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: width / (width ~/ wrap + 1) / height,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
