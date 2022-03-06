import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';

class VRChatMobileTokenSetting extends StatefulWidget {
  final bool offline;

  const VRChatMobileTokenSetting({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileTokenSetting> createState() => _TokenSettingPageState();
}

class _TokenSettingPageState extends State<VRChatMobileTokenSetting> {
  TextEditingController _tokenController = TextEditingController();

  _TokenSettingPageState() {
    getLoginSession("LoginSession").then((cookie) {
      setState(() {
        _tokenController = TextEditingController(text: cookie);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Token'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(children: <Widget>[
              TextField(
                controller: _tokenController,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Cookie'),
              ),
              ElevatedButton(
                child: const Text('保存'),
                onPressed: () {
                  setLoginSession("LoginSession", _tokenController.text).then((response) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("保存しました"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("閉じる"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        });
                  });
                },
              ),
              ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () {
                  VRChatAPI(cookie: _tokenController.text).user().then((response) {
                    if (response.containsKey("error")) {
                      error(context, response["error"]["message"]);
                      return;
                    }
                    if (response.containsKey("id")) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("成功しました"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("閉じる"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("失敗しました"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("閉じる"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          });
                    }
                  });
                },
              ),
            ])));
  }
}
