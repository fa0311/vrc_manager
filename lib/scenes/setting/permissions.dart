// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VRChatMobileSettingsPermissions extends StatefulWidget {
  const VRChatMobileSettingsPermissions({Key? key}) : super(key: key);

  @override
  State<VRChatMobileSettingsPermissions> createState() => _SettingPermissionsPageState();
}

class _SettingPermissionsPageState extends State<VRChatMobileSettingsPermissions> with WidgetsBindingObserver {
  Future<void> _domainRequest() async {
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

  Widget domainStageVerification = const CircularProgressIndicator();

  Future<void> _domainStageNone() async {
    if (await DomainVerificationManager.isSupported) {
      if (((await DomainVerificationManager.domainStageNone) ?? []).isEmpty) {
        setState(() {
          domainStageVerification = const Icon(
            Icons.check,
            color: Colors.green,
          );
        });
      } else {
        setState(() {
          domainStageVerification = const Icon(
            Icons.close,
            color: Colors.red,
          );
        });
      }
    } else {
      setState(() {
        domainStageVerification = const Icon(
          Icons.check,
          color: Colors.green,
        );
      });
    }
  }

  _SettingPermissionsPageState() {
    _domainStageNone();
  }

  @override
  Widget build(BuildContext context) {
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
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            domainStageVerification,
                          ],
                        ),
                        title: Text(AppLocalizations.of(context)!.domainVerification),
                        subtitle: Text(AppLocalizations.of(context)!.domainVerificationDetails),
                        onTap: () => _domainRequest()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _domainStageNone());
    }
  }
}
