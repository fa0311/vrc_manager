import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future showLicence(BuildContext context) async {
  final info = await PackageInfo.fromPlatform();

  showLicensePage(
    context: context,
    applicationName: info.appName,
    applicationVersion: info.version,
    applicationLegalese: '2022 yuki',
  );
}
