// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/data_class/notifier.dart';

class ThemeBrightnessModal extends ConsumerWidget {
  final StateNotifierProvider<ThemeBrightnessNotifier, ThemeBrightness> provider;

  const ThemeBrightnessModal(this.provider, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBrightness = ref.watch(provider);
    return Column(
      children: <Widget>[
        for (ThemeBrightness value in ThemeBrightness.values)
          ListTile(
            title: Text(value.toLocalization(context)),
            trailing: themeBrightness == value ? const Icon(Icons.check) : null,
            onTap: () {
              ref.read(provider.notifier).set(value);
            },
          ),
      ],
    );
  }
}
