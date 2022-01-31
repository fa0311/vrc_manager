import 'session.dart';
import 'package:flutter/material.dart';

class VRCAPI {
  late BuildContext context;
  final vrchatSession = Session();

  VRCAPI(BuildContext _context) {
    context = _context;
  }

  void login(username, password) {
    vrchatSession.get(Uri.parse("https://vrchat.com/api/1/config"));
    vrchatSession.basic(Uri.parse("https://vrchat.com/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"), username, password).then((response) {
      if (response.containsKey("error")) error(response["error"]["message"]);
      if (response.containsKey("requiresTwoFactorAuth")) totp();
      print(response);
    });
  }

  void loginTotp(code) {
    vrchatSession.post(Uri.parse("https://vrchat.com/api/1/auth/twofactorauth/totp/verify"), {"code": code}).then((response) {
      if (response.containsKey("error")) error(response["error"]["message"]);
      if (response["verified"]) print("成功");
      print(response);
    });
  }

  void error(text) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("エラーが発生しました"),
            content: Text(text),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
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
              decoration: const InputDecoration(labelText: 'TOTP'),
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
