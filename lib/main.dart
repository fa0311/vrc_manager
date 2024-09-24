// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
// Project imports:
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/storage/accessibility.dart';

ConsoleOutputExt loggerOutput = ConsoleOutputExt();
Logger logger = LoggerExt(
  filter: ProductionFilter(),
  printer: PrettyPrinter(methodCount: 8),
  output: loggerOutput,
  level: kDebugMode ? Level.trace : Level.warning,
);

main() {
  runApp(const ProviderScope(child: VRChatMobile()));
}

class VRChatMobile extends ConsumerWidget {
  const VRChatMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);

    return MaterialApp(
      title: 'VRChat Mobile Client',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(accessibilityConfig.languageCode.name, ''),
      theme: accessibilityConfig.themeBrightness.toTheme(),
      darkTheme: accessibilityConfig.darkThemeBrightness.toTheme(),
      home: const VRChatMobileSplash(),
    );
  }
}
