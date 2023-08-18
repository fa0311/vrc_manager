// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/widgets/future/button.dart';

final tokenControllerProvider = StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController(text: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
});

class VRChatMobileTokenSetting extends ConsumerWidget {
  final bool offline;
  const VRChatMobileTokenSetting({super.key, this.offline = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tokenController = ref.watch(tokenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.token),
      ),
      body: SafeArea(
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
                FutureButton(
                  type: ButtonType.elevatedButton,
                  onPressed: () async {
                    await ref.read(accountConfigProvider).loggedAccount!.setCookie(tokenController.text);
                    await ref.read(accountConfigProvider).login(ref.read(accountConfigProvider).loggedAccount!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.saved)),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
                FutureButton(
                  type: ButtonType.elevatedButton,
                  child: Text(AppLocalizations.of(context)!.login),
                  onPressed: () async {
                    await VRChatAPI(
                      cookie: tokenController.text,
                      userAgent: ref.watch(accountConfigProvider).userAgent,
                      logger: logger,
                    ).user().then((VRChatUserSelfOverload response) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.success)),
                      );
                    }).catchError((e, trace) {
                      logger.w(getMessage(e), error: e, stackTrace: trace);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.failed)),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
