// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/main.dart';

Future showThemeBrightnessModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => Column(
          children: <Widget>[
            for (ThemeBrightness e in ThemeBrightness.values)
              ListTile(
                title: Text(e.toLocalization(context)),
                trailing: appConfig.themeBrightness == e ? const Icon(Icons.check) : null,
                onTap: () {
                  appConfig.setThemeBrightness(e);
                  setStateBuilder(() {});
                  appConfig.setState(() {});
                },
              ),
          ],
        ),
      ),
    ),
  );
}
