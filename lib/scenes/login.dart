import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'dart:convert';

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
    final _passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("2段階認証"),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'コード'),
              maxLength: 6,
            ),
            actions: [
              TextButton(
                  child: const Text("送信"),
                  onPressed: () => session.loginTotp(_passwordController.text).then((response) {
                        if (response.containsKey("error")) {
                          error(context, response["error"]["message"]);
                        } else if (response.containsKey("verified") && response["verified"]) {
                          save(session.vrchatSession.headers["cookie"] as String);
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
        title: const Text('ログイン'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'ユーザー名/メールアドレス'),
            ),
            TextFormField(
              obscureText: _isPasswordObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'パスワード',
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
              child: const Text('ログイン'),
              onPressed: () => onPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
