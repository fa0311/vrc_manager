import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import '../widgets/drawer.dart';

class VRChatMobileSettings extends StatefulWidget {
  const VRChatMobileSettings({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettings> createState() => _LoginPageState();
}

class _LoginPageState extends State<VRChatMobileSettings> {
  _removeLoginSession() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'LoginSession');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const VRChatMobileLogin(),
        ),
        (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ElevatedButton(
                child: const Text('ログアウト'),
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("ログアウトしますか？"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => _removeLoginSession(),
                          ),
                        ],
                      );
                    },
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
