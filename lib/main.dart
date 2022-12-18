// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';
import 'package:vrc_manager/storage/accessibility.dart';

main() {
  runApp(const ProviderScope(child: VRChatMobile()));
}

class VRChatMobile extends ConsumerWidget {
  const VRChatMobile({Key? key}) : super(key: key);

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
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', ''),
        Locale('es', ''),
        Locale('pt', ''),
        Locale('ru', ''),
        Locale('th', ''),
        Locale('zh', ''),
      ],
      locale: Locale(accessibilityConfig.languageCode.name, ''),
      theme: accessibilityConfig.themeBrightness.toTheme(),
      darkTheme: accessibilityConfig.darkThemeBrightness.toTheme(),
      home: const VRChatMobileSplash(
        child: VRChatMobileHome(),
      ),
    );
  }
}
