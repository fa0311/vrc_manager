// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/enum.dart';
import 'package:vrc_manager/main.dart';

Future showThemeBrightnessModal(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) => Consumer(builder: (context, ref, _) {
      final themeBrightness = ref.watch(appConfig.themeBrightness);

      return Column(
        children: <Widget>[
          for (ThemeBrightness e in ThemeBrightness.values)
            ListTile(
              title: Text(e.toLocalization(context)),
              trailing: themeBrightness == e ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(appConfig.themeBrightness.notifier).set(e);
              },
            ),
        ],
      );
    }),
  );
}
