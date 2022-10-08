// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:package_info_plus/package_info_plus.dart';

Future<void> showLicense(BuildContext context) async {
  final PackageInfo info = await PackageInfo.fromPlatform();

  showLicensePage(
    context: context,
    applicationName: info.appName,
    applicationVersion: info.version,
    applicationLegalese: '2022 yuki',
  );
}
