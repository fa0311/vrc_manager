// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/api/main.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/dialog.dart';
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettingsOtherAccount extends StatefulWidget {
  final bool drawer;
  final AppConfig appConfig;
  final VRChatAPI vrhatLoginSession;
  const VRChatMobileSettingsOtherAccount(this.appConfig, this.vrhatLoginSession, {Key? key, this.drawer = true}) : super(key: key);

  @override
  State<VRChatMobileSettingsOtherAccount> createState() => _SettingOtherAccountPageState();
}

class _SettingOtherAccountPageState extends State<VRChatMobileSettingsOtherAccount> {
  Column column = Column();

  _onPressedRemoveAccount(BuildContext context, String accountIndex) async {
    removeLoginSession("displayname", accountIndex: accountIndex);
    removeLoginSession("userid", accountIndex: accountIndex);
    removeLoginSession("password", accountIndex: accountIndex);
    removeLoginSession("login_session", accountIndex: accountIndex);

    List<String> accountIndexList = await getStorageList("account_index_list");

    accountIndexList.remove(accountIndex);
    setStorageList("account_index_list", accountIndexList);

    String? accountIndexNow = await getStorage("account_index");
    if (accountIndexNow == accountIndex) {
      if (accountIndexList.isEmpty) {
        removeStorage("account_index").then(
          (_) => getLoginSession("login_session").then(
            (cookie) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VRChatMobileHome(widget.appConfig, widget.vrhatLoginSession),
              ),
              (_) => false,
            ),
          ),
        );
        return;
      } else {
        setStorage("account_index", accountIndexList[0]);
      }
    }
    reload();
  }

  _SettingOtherAccountPageState() {
    reload();
  }
  reload() {
    getStorageList("account_index_list").then(
      (response) {
        List<Widget> list = [
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            onPressed: () => removeStorage("account_index").then(
              (_) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => VRChatMobileHome(widget.appConfig, widget.vrhatLoginSession),
                ),
                (_) => false,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.addAccount),
          )
        ];
        List<Future> futureList = [];
        response.asMap().forEach(
          (_, String accountIndex) {
            futureList.add(
              getLoginSession("displayname", accountIndex: accountIndex).then(
                (accountName) => list.insert(
                  0,
                  Card(
                    elevation: 20.0,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () => setStorage("account_index", accountIndex).then(
                          (_) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => VRChatMobileHome(widget.appConfig, widget.vrhatLoginSession),
                            ),
                            (_) => false,
                          ),
                        ),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  accountName ?? AppLocalizations.of(context)!.unknown,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: IconButton(
                                onPressed: () => confirm(
                                  context,
                                  AppLocalizations.of(context)!.deleteLoginInfoConfirm,
                                  AppLocalizations.of(context)!.delete,
                                  () {
                                    _onPressedRemoveAccount(context, accountIndex);
                                    Navigator.pop(context);
                                  },
                                ),
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
        Future.wait(futureList).then(
          (value) => setState(
            () => column = Column(children: list),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig, widget.vrhatLoginSession);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
      ),
      drawer: widget.drawer ? drawer(context, widget.appConfig, widget.vrhatLoginSession) : null,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child: column),
        ),
      ),
    );
  }
}
