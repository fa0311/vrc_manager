// Dart imports:

// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileLoginData {
  AccountConfig accountConfig;
  VRChatAPI session;
  VRChatMobileLoginData({required this.accountConfig, required this.session});
}

String genUid([int length = 64]) {
  // cspell:disable-next-line
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final Random random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

final isPasswordObscureProvider = StateProvider.autoDispose<bool>((ref) => true);
final waitProvider = StateProvider.autoDispose<bool>((ref) => false);
final waitTotpProvider = StateProvider.autoDispose<bool>((ref) => false);
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
  if (ref.read(accountConfigProvider).isLogout()) {
    accountConfig = ref.read(accountConfigProvider).loggedAccount!;
  } else {
    accountConfig = AccountConfig(genUid());
  }
  return VRChatMobileLoginData(accountConfig: accountConfig, session: VRChatAPI(cookie: accountConfig.cookie));
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
      VRChatLogin login = await ref.read(loginDataProvider).session.loginTotp(ref.read(totpControllerProvider).text);
      if (login.verified) {
        await save();
      } else {
        // errorDialog(context, AppLocalizations.of(context)!.incorrectLogin);
      }
    }

    totp() {
      showDialog(
        context: context,
        builder: (_) {
          return Consumer(
            builder: (context, ref, child) {
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
                  TextButton(
                    child: ref.read(waitProvider)
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                        : Text(AppLocalizations.of(context)!.send),
                    onPressed: () => onPressedTotp(),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    onPressed() async {
      final session = ref.watch(loginDataProvider).session;
      VRChatLogin login = await session.login(ref.read(userControllerProvider).text, ref.read(passwordControllerProvider).text);
      if (login.requiresTwoFactorAuth) {
        totp();
      } else if (login.verified) {
        await save();
      } else {
        login.content.addAll({"lastEndpoint": "api/1/auth/user"});
        throw Exception(errorLog(login.content));
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
            ElevatedButton(
              child: ref.read(waitProvider)
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary))
                  : Text(
                      AppLocalizations.of(context)!.login,
                    ),
              onPressed: () => onPressed(),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.cantLogin,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.cantLogin),
                    content: Text(AppLocalizations.of(context)!.cantLoginDetails),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          openInBrowser(context, Uri.https("vrchat.com", "/home/login"));
                        },
                        child: Text(AppLocalizations.of(context)!.openInBrowser),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
