// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/theme/enum.dart';
import 'package:vrc_manager/storage/accessibility.dart';

class ThemeBrightnessModal extends ConsumerWidget {
  final bool dark;

  const ThemeBrightnessModal({super.key, required this.dark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          for (ThemeBrightness value in ThemeBrightness.values)
            ListTile(
              title: Text(value.toLocalization(context)),
              trailing: (dark ? accessibilityConfig.darkThemeBrightness : accessibilityConfig.themeBrightness) == value ? const Icon(Icons.check) : null,
              onTap: () => dark ? accessibilityConfig.setDarkThemeBrightness(value) : accessibilityConfig.setThemeBrightness(value),
            ),
        ],
      ),
    );
  }
}
