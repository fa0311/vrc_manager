// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/home.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal/locale.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileLogin extends StatefulWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLogin> createState() => _LoginPageState();
}

class _LoginPageState extends State<VRChatMobileLogin> {
  late VRChatAPI session;
  late AccountConfig accountConfig;
  bool _isPasswordObscure = true;
  bool _rememberPassword = false;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _totpController = TextEditingController();

  @override
  initState() {
    super.initState();
    if (appConfig.isLogout()) {
      accountConfig = appConfig.loggedAccount!;
      session = VRChatAPI(cookie: accountConfig.cookie);
      _userController.text = accountConfig.userId ?? "";
      _passwordController.text = accountConfig.password ?? "";
      _rememberPassword = accountConfig.rememberLoginInfo;
    } else {
      accountConfig = AccountConfig(genUid());
      session = VRChatAPI(cookie: accountConfig.cookie);
    }
  }

  _onPressed(context) {
    session.login(_userController.text, _passwordController.text).then((VRChatLogin login) {
      if (login.requiresTwoFactorAuth) {
        _totp();
      } else if (login.verified) {
        _save(session.getCookie());
      } else {
        login.content.addAll({"lastEndpoint": "api/1/auth/user"});
        throw Exception(errorLog(login.content));
      }
    }).catchError((status) {
      apiError(context, status);
    });
  }

  _onPressedTotp(context) {
    session.loginTotp(_totpController.text).then((VRChatLogin login) {
      if (login.verified) {
        _save(session.getCookie());
      } else {
        errorDialog(context, AppLocalizations.of(context)!.incorrectLogin);
      }
    }).catchError((status) {
      apiError(context, status);
    });
  }

  _totp() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.twoFactorAuthentication,
          ),
          content: TextFormField(
            keyboardType: TextInputType.number,
            controller: _totpController,
            onFieldSubmitted: (String e) => _onPressedTotp(context),
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.authenticationCode),
            maxLength: 6,
          ),
          actions: [
            TextButton(child: Text(AppLocalizations.of(context)!.send), onPressed: () => _onPressedTotp(context)),
          ],
        );
      },
    );
  }

  _save(String cookie) {
    if (!_rememberPassword) {
      _passwordController.text = "";
    }
    accountConfig.setUserId(_userController.text);
    accountConfig.setPassword(_passwordController.text);
    accountConfig.setCookie(cookie);
    accountConfig.setRememberLoginInfo(_rememberPassword);
    appConfig.addAccount(accountConfig);

    appConfig.login(context, accountConfig).then(
          (bool logged) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => logged ? const VRChatMobileHome() : const VRChatMobileLogin(),
            ),
            (_) => false,
          ),
        );
  }

  String genUid([int length = 64]) {
    // cspell:disable-next-line
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.translate,
            ),
            onPressed: () => showLocaleModal(context),
          ),
        ],
      ),
      drawer: simpleDrawer(context),
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _userController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.usernameOrEmail),
              ),
              TextFormField(
                obscureText: _isPasswordObscure,
                controller: _passwordController,
                onFieldSubmitted: (String e) => _onPressed(context),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isPasswordObscure = !_isPasswordObscure),
                  ),
                ),
              ),
              SwitchListTile(
                value: _rememberPassword,
                title: Text(
                  AppLocalizations.of(context)!.rememberPassword,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
                onChanged: (e) => setState(() => _rememberPassword = e),
              ),
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.login,
                ),
                onPressed: () => _onPressed(context),
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
                            openInBrowser(context, "https://vrchat.com/home/login");
                          },
                          child: Text(AppLocalizations.of(context)!.openInBrowser),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
