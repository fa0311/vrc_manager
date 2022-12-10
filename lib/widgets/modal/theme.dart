// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/widgets/modal.dart';

Future showThemeBrightnessModal(BuildContext context, WidgetRef ref) {
  return showModalBottomSheetStateless(
    context: context,
    builder: (context, ref, _) {
      final themeBrightness = ref.watch(themeBrightnessProvider);
      return Column(
        children: <Widget>[
          for (ThemeBrightness value in ThemeBrightness.values)
            ListTile(
              title: Text(value.toLocalization(context)),
              trailing: themeBrightness == value ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(themeBrightnessProvider.notifier).set(value);
              },
            ),
        ],
      );
    },
  );
}
