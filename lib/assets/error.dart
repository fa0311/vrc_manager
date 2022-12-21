// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

standardError(BuildContext context, dynamic error) {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfoPlugin.deviceInfo.then((BaseDeviceInfo deviceInfo) {
      Map<String, dynamic> logs = kDebugMode
          ? {
              "exceptionType": error.toString(),
              "error": error.toString(),
            }
          : {
              "exceptionType": error.toString(),
              "version": packageInfo.version,
              "deviceInfo": deviceInfo.data,
              "error": error.toString(),
            };
      if (error is TypeError) {
        logs.addAll({
          "stackTrace": (error.stackTrace ?? "").toString().split("\n"),
        });
      } else if (error is FormatException) {
        logs.addAll({
          "message": error.message,
        });
      } else if (error is SocketException) {
        logs.addAll({
          "message": error.message,
        });
      }
    });
  });
}
