import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../api/main.dart';
import 'home.dart';
import '../assets/error.dart';

class VRChatMobileLogin extends StatefulWidget {
  const VRChatMobileLogin({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLogin> createState() => _LoginPageState();
}

bool _isPasswordObscure = true;
final _userController = TextEditingController();
final _passwordController = TextEditingController();

void onPressed(context) {
  void save(String cookie) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "LoginSession", value: cookie);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const VRChatMobileHome(),
        ),
        (_) => false);
  }

  final session = VRChatAPI();
  void totp() {
    final _passwordController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Two-Factor Authentication"),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'code'),
              maxLength: 6,
            ),
            actions: [
              TextButton(
                  child: const Text("Verify"),
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
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextFormField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Username/Email'),
            ),
            TextFormField(
              obscureText: _isPasswordObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
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
              child: const Text('Login'),
              onPressed: () => onPressed(context),
            ),
          ],
        ),
      ),
    );
  }
}
