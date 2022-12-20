// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/storage/account.dart';

class VRChatMobileSettingsOtherAccount extends ConsumerWidget {
  const VRChatMobileSettingsOtherAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    return WillPopScope(
      onWillPop: () async {
        if (!ref.read(accountListConfigProvider).accountList.contains(ref.read(accountConfigProvider).loggedAccount)) {
          ref.read(accountConfigProvider).login(ref.read(accountListConfigProvider).accountList.first);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.accountSwitchSetting),
        ),
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (AccountConfig account in ref.watch(accountListConfigProvider).accountList)
                    Card(
                      elevation: 20.0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          await ref.read(accountConfigProvider).login(account);
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
                                                ref.read(accountListConfigProvider).removeAccount(account);
                                                Navigator.pop(context);
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
                      ref.read(accountConfigProvider).logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VRChatMobileSplash(),
                        ),
                        (_) => false,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.addAccount),
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
