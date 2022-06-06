import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VRChatMobileLogin extends StatefulWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLogin> createState() => _LoginPageState();
}

bool _isPasswordObscure = true;
final _userController = TextEditingController();
final _passwordController = TextEditingController();

void onPressed(context) {
  void save(String cookie) {
    setLoginSession("LoginSession", cookie).then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const VRChatMobileHome(),
          ),
          (_) => false);
    });
  }

  final session = VRChatAPI();
  void totp() {
    final passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              "AppLocalizations.of(context)!.two_factor_authentication",
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: passwordController,
              decoration: const InputDecoration(labelText: "AppLocalizations.of(context)!.authentication_code"),
              maxLength: 6,
            ),
            actions: [
              TextButton(
                  child: const Text("送信"),
                  onPressed: () => session.loginTotp(passwordController.text).then((response) {
                        if (response.containsKey("error")) {
                          error(context, response["error"]["message"]);
                        } else if (response.containsKey("verified") && response["verified"]) {
                          save(session.vrchatSession.headers["cookie"] as String);
                        } else if (response.containsKey("verified") && !response["verified"]) {
                          error(context, "ログイン情報が間違っています");
                        } else if (response.containsKey("id")) {
                          save(session.vrchatSession.headers["cookie"] as String);
                        } else {
                          error(context, "このアカウントのログイン方法は対応していません\n開発者に報告してください\nまた、報告をタップするとログがクリップボードにコピーされます", log: json.encode(response));
                        }
                      })),
            ],
          );
        });
  }

  session.login(_userController.text, _passwordController.text).then((response) {
    if (response.containsKey("error")) {
      error(context, response["error"]["message"]);
    } else if (response.containsKey("requiresTwoFactorAuth")) {
      totp();
    } else if (response.containsKey("verified") && response["verified"]) {
      save(session.vrchatSession.headers["cookie"] as String);
    } else if (response.containsKey("verified") && !response["verified"]) {
      error(context, "ログイン情報が間違っています");
    } else if (response.containsKey("id")) {
      save(session.vrchatSession.headers["cookie"] as String);
    } else {
      error(context, "このアカウントのログイン方法は対応していません\n開発者に報告してください\nまた、報告をタップするとログがクリップボードにコピーされます", log: json.encode(response));
    }
  });
}

class _LoginPageState extends State<VRChatMobileLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.username_or_email),
            ),
            TextFormField(
              obscureText: _isPasswordObscure,
              controller: _passwordController,
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
            Container(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.login,
              ),
              onPressed: () => onPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
