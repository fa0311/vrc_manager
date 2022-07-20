// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
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
    getLoginSession("login_session").then(
      (cookie) {
        setState(() => _tokenController = TextEditingController(text: cookie));
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.token),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _tokenController,
                    maxLines: null,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.cookie),
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.save),
                    onPressed: () {
                      setLoginSession("login_session", _tokenController.text).then((_) => showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.saved),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            },
                          ));
                    },
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.login),
                    onPressed: () {
                      VRChatAPI(cookie: _tokenController.text).user().then((VRChatUserOverload response) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.success),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(AppLocalizations.of(context)!.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
                      }).catchError((status) {
                        apiError(context, status);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
