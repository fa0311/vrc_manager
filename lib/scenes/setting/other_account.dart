// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/assets/dialog.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/scenes/home.dart';
import 'package:vrc_manager/scenes/login.dart';
import 'package:vrc_manager/widgets/drawer.dart';

class VRChatMobileSettingsOtherAccount extends StatefulWidget {
  final AppConfig appConfig;

  const VRChatMobileSettingsOtherAccount(this.appConfig, {Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsOtherAccount> createState() => _SettingOtherAccountPageState();
}

class _SettingOtherAccountPageState extends State<VRChatMobileSettingsOtherAccount> {
  Column column = Column();

  List<Widget> getAccountList() {
    List<Widget> list = [];
    for (AccountConfig account in widget.appConfig.accountList) {
      list.add(
        Card(
          elevation: 20.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                widget.appConfig.login(context, account);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileHome(widget.appConfig),
                  ),
                  (_) => false,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        account.displayName ?? AppLocalizations.of(context)!.unknown,
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
                          widget.appConfig.removeAccount(account);
                          setState(() {});
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
    return list;
  }

  @override
  Widget build(BuildContext context) {
    textStream(context, widget.appConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
      ),
      drawer: widget.appConfig.isLogout() ? drawer(context, widget.appConfig) : simpleDrawer(context, widget.appConfig),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(children: [
            ...getAccountList(),
            TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                widget.appConfig.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VRChatMobileLogin(
                      widget.appConfig,
                    ),
                  ),
                  (_) => false,
                );
              },
              child: Text(AppLocalizations.of(context)!.addAccount),
            ),
          ])),
        ),
      ),
    );
  }
}
