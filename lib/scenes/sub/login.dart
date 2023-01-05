// Dart imports:

// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/web/web_view_login.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/future/button.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileLoginData {
  AccountConfig accountConfig;
  VRChatAPI session;
  VRChatMobileLoginData({required this.accountConfig, required this.session});
}

String genUid([int length = 64]) {
  final Random random = Random.secure();
  return List.generate(length, (_) => Assets.charset[random.nextInt(Assets.charset.length)]).join();
}

final isPasswordObscureProvider = StateProvider.autoDispose<bool>((ref) => true);
final totpControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());

final userControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController()..text = ref.read(loginDataProvider).accountConfig.userId ?? "";
});

final passwordControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController()..text = ref.read(loginDataProvider).accountConfig.password ?? "";
});
final rememberPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return ref.read(loginDataProvider).accountConfig.rememberLoginInfo;
});

final loginDataProvider = StateProvider.autoDispose<VRChatMobileLoginData>((ref) {
  AccountConfig accountConfig;
  if (!ref.read(accountConfigProvider).isLogout()) {
    accountConfig = ref.read(accountConfigProvider).loggedAccount!;
  } else {
    accountConfig = AccountConfig(genUid());
  }
  return VRChatMobileLoginData(accountConfig: accountConfig, session: VRChatAPI(cookie: accountConfig.cookie ?? "", logger: logger));
});

class VRChatMobileLogin extends ConsumerWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future save() async {
      AccountConfig config = ref.read(loginDataProvider).accountConfig;
      config.setUserId(ref.read(userControllerProvider).text);

      if (ref.read(rememberPasswordProvider)) {
        config.setPassword(ref.read(passwordControllerProvider).text);
      } else {
        config.setPassword("");
      }

      config.setCookie(ref.read(loginDataProvider).session.getCookie());
      config.setRememberLoginInfo(ref.read(rememberPasswordProvider));
      ref.read(accountListConfigProvider).addAccount(config);

      await ref.read(accountConfigProvider).login(config);
    }

    onPressedTotp() async {
      try {
        VRChatLogin login = await ref.read(loginDataProvider).session.loginTotp(ref.read(totpControllerProvider).text);
        if (login.verified) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          save();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.incorrectLogin)),
          );
        }
      } catch (e, trace) {
        logger.e(getMessage(e), e, trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
      }
    }

    totp() {
      showDialog(
        context: context,
        builder: (_) {
          final totpController = ref.watch(totpControllerProvider);
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.twoFactorAuthentication,
            ),
            content: TextFormField(
              keyboardType: TextInputType.number,
              controller: totpController,
              onFieldSubmitted: (String e) => onPressedTotp(),
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.authenticationCode),
              maxLength: 6,
            ),
            actions: [
              FutureButton(
                child: Text(AppLocalizations.of(context)!.send),
                onPressed: () => onPressedTotp(),
              ),
            ],
          );
        },
      );
    }

    onPressed() async {
      try {
        final session = ref.watch(loginDataProvider).session;
        VRChatLogin login = await session.login(ref.read(userControllerProvider).text, ref.read(passwordControllerProvider).text);
        if (login.requiresTwoFactorAuth) {
          totp();
        } else if (login.verified) {
          await save();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.incorrectLogin)),
          );
        }
      } catch (e, trace) {
        logger.e(getMessage(e), e, trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.translate,
            ),
            onPressed: () => showModalBottomSheetStatelessWidget(
              context: context,
              builder: () => const LocaleModal(),
            ),
          ),
        ],
      ),
      drawer: const NormalDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                final userController = ref.watch(userControllerProvider);
                return TextFormField(
                  controller: userController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.usernameOrEmail),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final isPasswordObscure = ref.watch(isPasswordObscureProvider);
                final passwordController = ref.watch(passwordControllerProvider);
                return TextFormField(
                  obscureText: isPasswordObscure,
                  controller: passwordController,
                  onFieldSubmitted: (String e) => onPressed(),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => ref.read(isPasswordObscureProvider.notifier).update((state) => !state),
                    ),
                  ),
                );
              },
            ),
            Consumer(builder: (context, ref, child) {
              final rememberPassword = ref.watch(rememberPasswordProvider);
              return SwitchListTile(
                value: rememberPassword,
                title: Text(
                  AppLocalizations.of(context)!.rememberPassword,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
                onChanged: (e) => ref.read(rememberPasswordProvider.notifier).update((state) => e),
              );
            }),
            FutureButton(
              onPressed: () => onPressed(),
              type: ButtonType.elevatedButton,
              child: Text(AppLocalizations.of(context)!.login),
            ),
            if (Platform.isAndroid || Platform.isIOS)
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.loginBrowser,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const VRChatMobileSplash(
                        login: VRChatMobileWebViewLogin(),
                        child: VRChatMobileHome(),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
