// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/storage/accessibility.dart';

final domainStageVerificationProvider = FutureProvider<bool>((ref) async {
  if (await DomainVerificationManager.isSupported) {
    if (((await DomainVerificationManager.domainStageNone) ?? []).isEmpty) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
});

final appLifecycleProvider = Provider<AppLifecycleState>((ref) {
  final observer = VRChatMobileSettingsPermissionsObserver((value) => ref.state = value);
  final binding = WidgetsBinding.instance..addObserver(observer);
  ref.onDispose(() => binding.removeObserver(observer));
  return AppLifecycleState.resumed;
});

class VRChatMobileSettingsPermissionsObserver extends WidgetsBindingObserver {
  VRChatMobileSettingsPermissionsObserver(this._didChangeState);

  final ValueChanged<AppLifecycleState> _didChangeState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _didChangeState(state);
    super.didChangeAppLifecycleState(state);
  }
}

class VRChatMobileSettingsPermissions extends ConsumerWidget {
  const VRChatMobileSettingsPermissions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    textStream(context: context, forceExternal: accessibilityConfig.forceExternalBrowser);

    ref.listen<AppLifecycleState>(appLifecycleProvider, (previous, next) {
      if (next == AppLifecycleState.resumed) {
        return ref.refresh(domainStageVerificationProvider.future);
      }
    });

    Future<void> domainRequest() async {
      if (await DomainVerificationManager.isSupported) {
        await DomainVerificationManager.domainRequest();
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.notSupported,
              ),
              content: Text(
                AppLocalizations.of(context)!.notSupportedDetails,
              ),
              actions: [
                TextButton(
                  child: Text(AppLocalizations.of(context)!.send),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }

    AsyncValue<bool> domainStageVerification = ref.watch(domainStageVerificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.permissions),
      ),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  if (Platform.isAndroid || Platform.isIOS)
                    ListTile(
                      leading: domainStageVerification.when(
                        loading: () => const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                        error: (e, trace) {
                          logger.w(getMessage(e), e, trace);
                          return const Icon(
                            Icons.close,
                            color: Colors.red,
                          );
                        },
                        data: (data) {
                          if (data) {
                            return const Icon(
                              Icons.check,
                              color: Colors.green,
                            );
                          } else {
                            return const Icon(
                              Icons.close,
                              color: Colors.red,
                            );
                          }
                        },
                      ),
                      title: Text(AppLocalizations.of(context)!.domainVerification),
                      subtitle: Text(AppLocalizations.of(context)!.domainVerificationDetails),
                      onTap: () => domainRequest(),
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
