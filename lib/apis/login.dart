import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../assets/session.dart';

class VRChatMobileAPILogin {
  late BuildContext context;
  final vrchatSession = Session();
  // ignore: prefer_function_declarations_over_variables
  void Function(Session vrchatSession) success = (Session vrchatSession) {};

  VRChatMobileAPILogin(BuildContext _context, _success) {
    context = _context;
    success = _success;
  }

  void login(username, password) {
    vrchatSession.get(Uri.parse("https://vrchat.com/api/1/config"));
    vrchatSession.basic(Uri.parse("https://vrchat.com/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"), username, password).then((response) {
      if (response.containsKey("error")) {
        error(response["error"]["message"]);
      } else if (response.containsKey("requiresTwoFactorAuth")) {
        totp();
      } else if (response.containsKey("verified") && response["verified"]) {
        success(vrchatSession);
      } else if (response.containsKey("id")) {
        success(vrchatSession);
      } else {
        error("このアカウントのログイン方法は対応していません\n開発者に報告してください\nまた、報告をタップするとログがクリップボードにコピーされます", log: json.encode(response));
      }
    });
  }

  void loginTotp(code) {
    vrchatSession.post(Uri.parse("https://vrchat.com/api/1/auth/twofactorauth/totp/verify"), {"code": code}).then((response) {
      if (response.containsKey("error")) {
        error(response["error"]["message"]);
      } else if (response.containsKey("verified") && response["verified"]) {
        success(vrchatSession);
      } else if (response.containsKey("id")) {
        success(vrchatSession);
      } else {
        error("このアカウントのログイン方法は対応していません\n開発者に報告してください\nまた、報告をタップするとログがクリップボードにコピーされます", log: json.encode(response));
      }
    });
  }

  void error(String text, {String log = ""}) {
    final List<TextButton> actions = [
      TextButton(
        child: const Text("OK"),
        onPressed: () => Navigator.pop(context),
      ),
    ];
    if (log.isNotEmpty) {
      actions.insert(
          0,
          TextButton(
            child: const Text("報告"),
            onPressed: () async {
              _launchURL() async {
                if (await canLaunch("https://github.com/fa0311/vrchat_mobile_client/issues/new")) {
                  await launch("https://github.com/fa0311/vrchat_mobile_client/issues/new");
                }
              }

              final data = ClipboardData(text: log);
              await Clipboard.setData(data);
              _launchURL();
            },
          ));
    }

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("エラーが発生しました"),
            content: Text(text),
            actions: actions,
          );
        });
  }

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
                onPressed: () => loginTotp(_passwordController.text),
              ),
            ],
          );
        });
  }
}
