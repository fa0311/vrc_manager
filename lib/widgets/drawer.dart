// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/main/settings.dart';
import 'package:vrc_manager/scenes/setting/other_account.dart';
import 'package:vrc_manager/scenes/sub/self.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/user.dart';

class AccountList extends ConsumerWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (AccountConfig account in ref.watch(accountListConfigProvider).accountList)
            ListTile(
              title: Text(
                account.displayName ?? AppLocalizations.of(context)!.unknown,
              ),
              onTap: () async {
                ref.read(accountConfigProvider).login(account);
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VRChatMobileSplash(
                  login: VRChatMobileSettingsOtherAccount(),
                  child: VRChatMobileSettingsOtherAccount(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NormalDrawer extends ConsumerWidget {
  const NormalDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccountConfig? account = ref.watch(accountConfigProvider).loggedAccount;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            if (account?.data != null)
              GestureDetector(
                onTapUp: (_) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VRChatMobileSelf(),
                  ),
                ),
                onLongPress: () {
                  showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => SelfUserModalBottom(user: account!.data!),
                  );
                },
                child: UserAccountsDrawerHeader(
                  accountName: Text(account!.data!.username),
                  accountEmail: Text(account.data!.statusDescription ?? ""),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(account.data!.profilePicOverride ?? account.data!.currentAvatarImageUrl),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (account?.data != null)
                      ListTile(
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VRChatMobileSplash(),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VRChatMobileSettings(),
                    ),
                  ),
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.setting),
                ),
                ListTile(
                  onTap: () => showModalBottomSheetStatelessWidget(
                    context: context,
                    builder: () => const AccountList(),
                  ),
                  leading: const Icon(Icons.account_circle),
                  title: Text(AppLocalizations.of(context)!.accountSwitch),
                ),
              ]),
            if (MediaQuery.of(context).size.height <= 500)
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VRChatMobileSettings(),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheetStatelessWidget(
                      context: context,
                      builder: () => const AccountList(),
                    ),
                    icon: const Icon(Icons.account_circle),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
