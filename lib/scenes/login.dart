// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileLogin extends StatefulWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLogin> createState() => _LoginPageState();
}

class _LoginPageState extends State<VRChatMobileLogin> {
  bool _isPasswordObscure = true;
  bool _rememberLoginInfo = false;
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _totpController = TextEditingController();
  late VRChatAPI session = VRChatAPI();

  _onPressed(context) {
    session.login(_userController.text, _passwordController.text).then((response) {
      if (response.containsKey("error")) {
        error(context, response["error"]["message"]);
      } else if (response.containsKey("requiresTwoFactorAuth")) {
        _totp();
      } else if (response.containsKey("verified") && response["verified"]) {
        _save(session.vrchatSession.headers["cookie"] as String);
      } else if (response.containsKey("verified") && !response["verified"]) {
        error(context, AppLocalizations.of(context)!.incorrectLogin);
      } else if (response.containsKey("id")) {
        _save(session.vrchatSession.headers["cookie"] as String);
      } else {
        error(context,
            "${AppLocalizations.of(context)!.unexpectedError}\n${AppLocalizations.of(context)!.reportMessage1}\n${AppLocalizations.of(context)!.reportMessage2(AppLocalizations.of(context)!.report)}",
            log: json.encode(response));
      }
    });
  }

  _onPressedTotp(context) {
    session.loginTotp(_totpController.text).then((response) {
      if (response.containsKey("error")) {
        error(context, response["error"]["message"]);
      } else if (response.containsKey("verified") && response["verified"]) {
        _save(session.vrchatSession.headers["cookie"] as String);
      } else if (response.containsKey("verified") && !response["verified"]) {
        error(context, AppLocalizations.of(context)!.incorrectLogin);
      } else if (response.containsKey("id")) {
        _save(session.vrchatSession.headers["cookie"] as String);
      } else {
        error(context,
            "${AppLocalizations.of(context)!.unexpectedError}\n${AppLocalizations.of(context)!.reportMessage1}\n${AppLocalizations.of(context)!.reportMessage2(AppLocalizations.of(context)!.report)}",
            log: json.encode(response));
      }
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
        });
  }

  _save(String cookie) {
    if (_rememberLoginInfo) {
      setLoginSession("UserId", _userController.text);
      setLoginSession("Password", _passwordController.text);
    } else {
      setLoginSession("UserId", "");
      setLoginSession("Password", "");
    }
    setLoginSession("LoginSession", cookie).then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobileHome(),
          ),
          (_) => false);
    });
  }

  _LoginPageState() {
    getLoginSession("LoginSession").then((response) {
      session = VRChatAPI(cookie: response);
    });
    getLoginSession("UserId").then((response) {
      setState(() => _userController.text = response);
    });
    getLoginSession("Password").then((response) {
      setState(() => _passwordController.text = response);
    });
    getStorage("remember_login_info").then((response) {
      setState(() => _rememberLoginInfo = (response == "true"));
    });
  }

  _changeSwitchRememberLoginInfo(bool e) {
    setStorage("remember_login_info", e ? "true" : "false").then((response) {
      setState(() => _rememberLoginInfo = e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      drawer: simpleDrawr(context),
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
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
              ),
            ),
            SwitchListTile(
              value: _rememberLoginInfo,
              title: Text(AppLocalizations.of(context)!.rememberLoginInfo,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  )),
              onChanged: _changeSwitchRememberLoginInfo,
            ),
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.login,
              ),
              onPressed: () => _onPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
