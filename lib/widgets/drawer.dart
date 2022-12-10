// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/main/settings.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/widgets/modal.dart';

Widget getAccountList() {
  AccountConfig? login;
  return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
    return SingleChildScrollView(
      child: Column(children: [
        for (AccountConfig account in appConfig.accountList)
          ListTile(
            title: Text(
              account.displayName ?? AppLocalizations.of(context)!.unknown,
            ),
            trailing: login == account
                ? const Padding(
                    padding: EdgeInsets.only(right: 2, top: 2),
                    child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                  )
                : null,
            onTap: () async {
              login = account;
              bool logged = await appConfig.login(context, account);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => logged ? const VRChatMobileHome() : const VRChatMobileLogin(),
                ),
                (_) => false,
              );
            },
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const VRChatMobileSettingsOtherAccount(),
            ),
            (_) => false,
          ),
        )
      ]),
    );
  });
}

Drawer drawer() {
  return Drawer(
    child: SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileHome(),
                        ),
                        (_) => false,
                      ),
                      leading: const Icon(Icons.home),
                      title: Text(AppLocalizations.of(context)!.home),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.close),
                    ),
                  ],
                ),
              ),
            ),
            if (MediaQuery.of(context).size.height > 500)
              Column(children: [
                const Divider(),
                ListTile(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VRChatMobileSettings(),
                    ),
                    (_) => false,
                  ),
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.setting),
                ),
                ListTile(
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => getAccountList(),
                  ),
                  leading: const Icon(Icons.account_circle),
                  title: Text(AppLocalizations.of(context)!.accountSwitch),
                ),
              ]),
            if (MediaQuery.of(context).size.height <= 500)
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSettings(),
                      ),
                      (_) => false,
                    ),
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheetStatelessWidget(
                      context: context,
                      builder: () => getAccountList(),
                    ),
                    icon: const Icon(Icons.account_circle),
                  ),
                ],
              )
          ],
        ),
      ),
    ),
  );
}

Drawer simpleDrawer() {
  return Drawer(
    child: SafeArea(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, _) => Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                ListTile(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VRChatMobileHome(),
                    ),
                    (_) => false,
                  ),
                  leading: const Icon(Icons.home),
                  title: Text(AppLocalizations.of(context)!.home),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.close),
                )
              ]),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSettings(),
                      ),
                      (_) => false,
                    ),
                    leading: const Icon(Icons.settings),
                    title: Text(AppLocalizations.of(context)!.setting),
                  ),
                  ListTile(
                    onTap: () => showModalBottomSheetStatelessWidget(
                      context: context,
                      builder: () => getAccountList(),
                    ),
                    leading: const Icon(Icons.account_circle),
                    title: Text(AppLocalizations.of(context)!.accountSwitch),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
