// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  const VRChatMobileSettingsOtherAccount(this.appConfig, {Key? key, this.drawer = true}) : super(key: key);

  @override
  State<VRChatMobileSettingsOtherAccount> createState() => _SettingOtherAccountPageState();
}

class _SettingOtherAccountPageState extends State<VRChatMobileSettingsOtherAccount> {
  Column column = Column();

  _onPressedRemoveAccount(BuildContext context, String accountUid) async {
    removeLoginSession("displayname", accountUid);
    removeLoginSession("userid", accountUid);
    removeLoginSession("password", accountUid);
    removeLoginSession("login_session", accountUid);

    for (AccountConfig account in widget.appConfig.accountList) {
      if (account.accountUid == accountUid) {
        widget.appConfig.accountList.remove(account);
      }
    }

    if (widget.appConfig.accountUid == accountUid) {
      if (widget.appConfig.accountList.isEmpty) {
        removeStorage("account_index").then(
          (_) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileHome(
                widget.appConfig,
              ),
            ),
            (_) => false,
          ),
        );
      } else {
        setStorage("account_index", widget.appConfig.accountList[0].accountUid);
      }
    }
    initState();
  }

  @override
  initState() {
    super.initState();
    List<Widget> list = [
      TextButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: () => removeStorage("account_index").then(
          (_) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => VRChatMobileHome(
                widget.appConfig,
              ),
            ),
            (_) => false,
          ),
        ),
        child: Text(AppLocalizations.of(context)!.addAccount),
      )
    ];
    for (AccountConfig account in widget.appConfig.accountList) {
      list.insert(
        0,
        Card(
          elevation: 20.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => setStorage("account_index", account.accountUid).then(
                (_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileHome(
                      widget.appConfig,
                    ),
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
                        account.username ?? AppLocalizations.of(context)!.unknown,
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
                          _onPressedRemoveAccount(context, account.accountUid);
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
      );
    }
    setState(
      () => column = Column(children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(
      context,
      widget.appConfig,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
      ),
      drawer: widget.drawer
          ? drawer(
              context,
              widget.appConfig,
            )
          : null,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(child: column),
        ),
      ),
    );
  }
}
