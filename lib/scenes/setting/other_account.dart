// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/dialog.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/home.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileSettingsOtherAccount extends StatefulWidget {
  final bool drawer;
  const VRChatMobileSettingsOtherAccount({Key? key, this.drawer = true}) : super(key: key);

  @override
  State<VRChatMobileSettingsOtherAccount> createState() => _SettingOtherAccountPageState();
}

class _SettingOtherAccountPageState extends State<VRChatMobileSettingsOtherAccount> {
  Column column = Column();

  _onPressedRemoveAccount(BuildContext context, String accountIndex) async {
    removeLoginSession("userid", accountIndex: accountIndex);
    removeLoginSession("password", accountIndex: accountIndex);
    removeLoginSession("login_session", accountIndex: accountIndex);

    List<String> accountIndexList = await getStorageList("account_index_list");

    accountIndexList.remove(accountIndex);
    setStorageList("account_index_list", accountIndexList).then(
      (_) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const VRChatMobileSettingsOtherAccount(),
          ),
        );
      },
    );

    String? accountIndexNow = await getStorage("account_index");
    if (accountIndexNow == accountIndex) {
      if (accountIndexList.isEmpty) {
        removeStorage("account_index").then(
          (_) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const VRChatMobileHome(),
            ),
            (_) => false,
          ),
        );
      } else {
        setStorage("account_index", accountIndexList[0]);
      }
    }
  }

  _SettingOtherAccountPageState() {
    getStorageList("account_index_list").then(
      (response) {
        List<Widget> list = [
          TextButton(
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.grey,
            ),
            onPressed: () => removeStorage("account_index").then(
              (_) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const VRChatMobileHome(),
                ),
                (_) => false,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.addAccount),
          )
        ];
        response.asMap().forEach(
          (_, String accountIndex) {
            getLoginSession("userid", accountIndex: accountIndex).then(
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
                            builder: (BuildContext context) => const VRChatMobileHome(),
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
                                accountName ?? "Unknown",
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
            );
          },
        );
        setState(
          () => column = Column(children: list),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
      ),
      drawer: widget.drawer ? drawer(context) : null,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child: column),
        ),
      ),
    );
  }
}
