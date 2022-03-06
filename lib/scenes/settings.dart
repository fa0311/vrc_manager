import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/main.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/scenes/setting/token.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettings extends StatefulWidget {
  const VRChatMobileSettings({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettings> createState() => _SettingPageState();
}

class _SettingPageState extends State<VRChatMobileSettings> {
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

  bool theme = false;
  void _changeSwitch(bool e) {
    setStorage("theme_brightness", e ? "dark" : "light").then((response) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const VRChatMobile(),
          ),
          (_) => false);
    });
    setState(() => theme = e);
  }

  _SettingPageState() {
    getStorage("theme_brightness").then((response) {
      setState(() => theme = (response == "dark"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SwitchListTile(
                value: theme,
                title: const Text('ダークテーマ'),
                subtitle: const Text('目に優しいダークテーマに切り替えます'),
                onChanged: _changeSwitch,
              ),
              const Divider(),
              ListTile(
                title: const Text('ログアウト'),
                subtitle: const Text('ログアウトし端末からログイン情報を削除します'),
                onTap: () => {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("ログアウトしますか？"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("キャンセル"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("ログアウト"),
                            onPressed: () => _removeLoginSession(),
                          ),
                        ],
                      );
                    },
                  ),
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Token'),
                subtitle: const Text('認証情報を確認または変更できます'),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VRChatMobileTokenSetting(),
                      ))
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
