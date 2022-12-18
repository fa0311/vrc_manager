// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/sub/splash.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/widgets/drawer.dart';

class VRChatMobileSettingsOtherAccount extends ConsumerWidget {
  const VRChatMobileSettingsOtherAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
      ),
      drawer: ref.read(accountConfigProvider.notifier).isLogout() ? const NormalDrawer() : const SimpleDrawer(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(children: [
            for (AccountConfig account in ref.read(accountConfigProvider.notifier).accountList)
              Card(
                elevation: 20.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    bool logged = await ref.read(accountConfigProvider.notifier).login(account);
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => logged ? const VRChatMobileHome() : const VRChatMobileLogin(),
                      ),
                      (_) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
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
                        if (ref.read(accountConfigProvider) == account) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                        SizedBox(
                          width: 50,
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.deleteLoginInfoConfirm),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref.read(accountConfigProvider.notifier).removeAccount(account);
                                        },
                                        child: Text(AppLocalizations.of(context)!.delete),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                ref.read(accountConfigProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const VRChatMobileLogin(),
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
