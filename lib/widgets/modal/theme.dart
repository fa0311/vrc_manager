// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/data_class/app_config.dart';

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
    builder: (BuildContext context) => Consumer(
      builder: (context, ref, _) => StatefulBuilder(
        builder: (BuildContext context, setState) => Column(
          children: <Widget>[
            for (ThemeBrightness e in ThemeBrightness.values)
              ListTile(
                title: Text(e.toLocalization(context)),
                trailing: appConfig.themeBrightness.value == e ? const Icon(Icons.check) : null,
                onTap: () {
                  ThemeBrightnessProvider themeBrightness = ref.read(appConfig.themeBrightness);
                  themeBrightness.set(e);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
