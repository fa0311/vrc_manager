// Dart imports:

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/storage2.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/web/web_view_login.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/future/button.dart';
import 'package:vrc_manager/widgets/config_modal/locale.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/loading.dart';
import 'package:vrc_manager/widgets/modal.dart';

class VRChatMobileLoginData {
  AccountConfig accountConfig;
  VRChatAPI session;
  VRChatMobileLoginData({required this.accountConfig, required this.session});
}

final usernameControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final passwordControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final passwordObscureProvider = StateProvider<bool>((ref) => true);
final rememberLoginInfoProvider = StateProvider<bool>((ref) => false);
final totpControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

// =====================

final loginStorageProvider = FutureProvider<void>((ref) async {
  final id = await ref.watch(selectedIdProvider.future);
  final storage = ConfigStorage(id: id);
  await Future.wait([
    storage.getSecure(key: ConfigStorageKey.username).then((value) {
      ref.read(usernameControllerProvider.notifier).state.text = value ?? "";
    }),
    storage.getSecure(key: ConfigStorageKey.password).then((value) {
      ref.read(passwordControllerProvider.notifier).state.text = value ?? "";
    }),
    storage.getBool(key: ConfigStorageKey.rememberLoginInfoKey).then((value) {
      ref.read(rememberLoginInfoProvider.notifier).state = value ?? false;
    }),
  ]);
});

class VRChatMobileLogin extends ConsumerWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(loginStorageProvider);

    final usernameController = ref.watch(usernameControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final totpController = ref.watch(totpControllerProvider);
    final passwordObscure = ref.watch(passwordObscureProvider);
    final rememberLoginInfo = ref.watch(rememberLoginInfoProvider);

    Future save() async {
      final id = await ref.read(selectedIdProvider.future);
      final storage = ConfigStorage(id: id);
      storage.setSecure(key: ConfigStorageKey.username, value: usernameController.text);
      storage.setBool(key: ConfigStorageKey.rememberLoginInfoKey, value: rememberLoginInfo);
      if (passwordObscure) {
        storage.setSecure(key: ConfigStorageKey.password, value: passwordController.text);
      }
      logger.i("saved");
      return await ref.refresh(selectedIdProvider);
    }

    Future onPressedTotp() async {
      try {
        final session = await ref.read(getSessionProvider.future);
        final response = await session.auth.verify2fa(totpController.text);
        if (response.error != null) throw response.error!;
        await save();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e, trace) {
        logger.e(getMessage(e), e, trace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage(context: context, status: e))));
      }
    }

    totp() {
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
    }

    Future onPressed() async {
      try {
        final session = await ref.read(getSessionProvider.future);
        final response = await session.auth.login(username: usernameController.text, password: passwordController.text);

        if (response.error != null) throw response.error!;
        if (response.requiresTwoFactorAuth) return showDialog(context: context, builder: (_) => totp());
        await save();
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
      body: data.when(
        loading: () => const Loading(),
        error: (e, trace) {
          logger.w(getMessage(e), e, trace);
          return ErrorPage(loggerReport: ref.read(loggerReportProvider));
        },
        data: (_) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.usernameOrEmail),
                ),
                TextFormField(
                  obscureText: passwordObscure,
                  controller: passwordController,
                  onFieldSubmitted: (_) => onPressed(),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                    suffixIcon: IconButton(
                      icon: Icon(passwordObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => ref.read(passwordObscureProvider.notifier).update((state) => !state),
                    ),
                  ),
                ),
                SwitchListTile(
                  value: rememberLoginInfo,
                  title: Text(
                    AppLocalizations.of(context)!.rememberPassword,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (e) => ref.read(rememberLoginInfoProvider.notifier).state = e,
                ),
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
          );
        },
      ),
    );
  }
}
