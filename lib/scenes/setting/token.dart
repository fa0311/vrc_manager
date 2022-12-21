// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/scenes/core/splash.dart';

final tokenControllerProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: ref.watch(accountConfigProvider).loggedAccount!.cookie);
});

class VRChatMobileTokenSetting extends ConsumerWidget {
  final bool offline;
  const VRChatMobileTokenSetting({super.key, this.offline = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tokenController = ref.watch(tokenControllerProvider);

    textStream(context);
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
                    controller: tokenController,
                    maxLines: null,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.cookie),
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.save),
                    onPressed: () {
                      ref.read(accountConfigProvider).loggedAccount!.setCookie(tokenController.text);
                      showDialog(
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
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.login),
                    onPressed: () {
                      VRChatAPI(cookie: tokenController.text).user().then((VRChatUserSelfOverload response) {
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
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.failed),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(AppLocalizations.of(context)!.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
                        );
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
