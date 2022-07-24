// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileLogin extends StatefulWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLogin> createState() => _LoginPageState();
}

class _LoginPageState extends State<VRChatMobileLogin> {
  bool _isPasswordObscure = true;
  bool _rememberPassword = false;
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _totpController = TextEditingController();
  late VRChatAPI session = VRChatAPI();

  _onPressed(context) {
    session.login(_userController.text, _passwordController.text).then((VRChatLogin login) {
      if (login.requiresTwoFactorAuth) {
        _totp();
      } else if (login.verified) {
        _save(session.vrchatSession.headers["cookie"] as String);
      } else {
        otherError(context, AppLocalizations.of(context)!.unexpectedError, content: login.content);
      }
    }).catchError((status) {
      apiError(context, status);
    });
  }

  _onPressedTotp(context) {
    session.loginTotp(_totpController.text).then((VRChatLogin login) {
      if (login.verified) {
        _save(session.vrchatSession.headers["cookie"] as String);
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
    if (_rememberPassword) {
      setLoginSession("password", _passwordController.text);
    }
    setLoginSession("userid", _userController.text);
    setLoginSession("login_session", cookie).then(
      (_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobileHome(),
          ),
          (_) => false,
        );
      },
    );
  }

  String _generateNonce([int length = 64]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  _LoginPageState() {
    getStorage("account_index").then(
      (response) {
        if (response == null) {
          String key = _generateNonce();
          setStorage("account_index", key);
          getStorageList("account_index_list").then(
            (accountIndexList) {
              accountIndexList.add(key);
              setStorageList("account_index_list", accountIndexList);
            },
          );
        } else {
          getLoginSession("login_session").then(
            (response) {
              session = VRChatAPI(cookie: response ?? "");
            },
          );
          getLoginSession("userid").then(
            (response) {
              setState(() => _userController.text = response ?? "");
            },
          );
          getLoginSession("password").then(
            (response) {
              setState(() => _passwordController.text = response ?? "");
            },
          );
          getStorage("remember_login_info").then(
            (response) {
              setState(() => _rememberPassword = (response == "true"));
            },
          );
        }
      },
    );
  }

  _changeSwitchrememberPassword(bool e) {
    setStorage("remember_login_info", e ? "true" : "false").then(
      (_) {
        setState(() => _rememberPassword = e);
      },
    );
  }

  ListTile _changeLocaleDialogOption(BuildContext context, String title, String languageCode) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        AppLocalizations.of(context)!.translaterDetails(lookupAppLocalizations(
          Locale(languageCode, ""),
        ).contributor),
      ),
      onTap: () async {
        setStorage("language_code", languageCode).then(
          (_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const VRChatMobile(),
              ),
              (_) => false,
            );
          },
        );
      },
    );
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
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              builder: (BuildContext context) => SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _changeLocaleDialogOption(context, 'English', 'en'),
                    _changeLocaleDialogOption(context, '日本語', 'ja'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: simpledrawer(context),
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
                    onPressed: () {
                      setState(
                        () {
                          _isPasswordObscure = !_isPasswordObscure;
                        },
                      );
                    },
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
                onChanged: _changeSwitchrememberPassword,
              ),
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.login,
                ),
                onPressed: () => _onPressed(context),
              ),
            ],
          )),
    );
  }
}
