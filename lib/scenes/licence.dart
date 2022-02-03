import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VRChatMobileLicence extends StatefulWidget {
  const VRChatMobileLicence({Key? key}) : super(key: key);

  @override
  State<VRChatMobileLicence> createState() => _LicenceState();
}

class _LicenceState extends State<VRChatMobileLicence> {
  @override
  Widget build(BuildContext context) {
    _addLicence() async {
      final info = await PackageInfo.fromPlatform();

      showLicensePage(
        context: context,
        applicationName: info.appName,
        applicationVersion: info.version,
        applicationLegalese: '2022 yuki',
      );
    }

    _addLicence();
    return Column();
  }
}
