// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/main.dart';

Future showThemeBrightnessModal(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => SingleChildScrollView(
      child: Consumer(
        builder: (context, ref, _) {
          final themeBrightness = ref.watch(appConfig.themeBrightness);

          return Column(
            children: <Widget>[
              for (ThemeBrightness value in ThemeBrightness.values)
                ListTile(
                  title: Text(value.toLocalization(context)),
                  trailing: themeBrightness == value ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(appConfig.themeBrightness.notifier).set(value);
                  },
                ),
            ],
          );
        },
      ),
    ),
  );
}
