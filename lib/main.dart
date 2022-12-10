// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vrc_manager/assets/theme/enum.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/l10n/code.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';

AppConfig appConfig = AppConfig();
main() {
  runApp(const ProviderScope(child: VRChatMobile()));
}

class VRChatMobile extends ConsumerWidget {
  const VRChatMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeBrightness themeBrightness = ref.watch(themeBrightnessProvider);
    ThemeBrightness darkThemeBrightness = ref.watch(darkThemeBrightnessProvider);
    LanguageCode languageCode = ref.watch(languageCodeProvider);

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
      locale: Locale(languageCode.name, ''),
      theme: themeBrightness.toTheme(),
      darkTheme: darkThemeBrightness.toTheme(),
      home: const VRChatMobileSplash(),
    );
  }
}
