// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

void errorDialog(BuildContext context, AppConfig appConfig, String text, {String log = ""}) {
  if (log.isNotEmpty) {
    text += "\n${AppLocalizations.of(context)!.reportMessage1}\n${AppLocalizations.of(context)!.reportMessage2}";
  }
  if (kDebugMode) {
    print(errorLog(json.decode(log)));
  }
  if (!appConfig.dontShowErrorDialog && log.isNotEmpty) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.errorDialog),
          content: Text(text),
          actions: [
            if (log.isNotEmpty)
              TextButton(
                child: Text(AppLocalizations.of(context)!.report),
                onPressed: () async {
                  await copyToClipboard(context, log);
                  /*
                    * To be fixed in the next stable version.
                    * if(context.mounted)
                    */
                  // ignore: use_build_context_synchronously
                  openInBrowser(context, appConfig, "https://github.com/fa0311/vrchat_mobile_client/issues/new/choose");
                },
              ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}

String errorLog(Map log) {
  JsonEncoder encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(log);
}

httpError(BuildContext context, AppConfig appConfig, HttpException error) {
  try {
    VRChatError content;
    dynamic message;
    if (error.message.startsWith('<html>')) {
      content = VRChatError.fromHtml(error.message);
      message = content.message;
    } else {
      message = json.decode(error.message);
      content = VRChatError.fromJson(message);
    }
    if (content.message == '"Missing Credentials"') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileLogin(appConfig),
        ),
        (_) => false,
      );
    } else if (content.message == 'Too many requests') {
      errorDialog(context, appConfig, AppLocalizations.of(context)!.tooManyRequests);
    } else if (content.message == '"Invalid Username/Email or Password"') {
      errorDialog(context, appConfig, AppLocalizations.of(context)!.invalidLoginInfo);
    } else {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        deviceInfoPlugin.deviceInfo.then((BaseDeviceInfo deviceInfo) {
          Map<String, dynamic> logs = kDebugMode
              ? {
                  "exceptionType": error.toString(),
                  "error": error.toString(),
                  "message": message,
                }
              : {
                  "exceptionType": error.toString(),
                  "version": packageInfo.version,
                  "deviceInfo": deviceInfo.toMap(),
                  "error": error.toString(),
                  "message": message,
                };
          errorDialog(context, appConfig, content.message, log: errorLog(logs));
        });
      });
    }
  } catch (e) {
    standardError(context, appConfig, e);
    return;
  }
}

standardError(BuildContext context, AppConfig appConfig, dynamic error) {
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
              "deviceInfo": deviceInfo.toMap(),
              "error": error.toString(),
            };
      if (error is TypeError) {
        logs.addAll({
          "stackTrace": (error.stackTrace ?? "").toString().split("\n"),
        });
        errorDialog(context, appConfig, AppLocalizations.of(context)!.parseError, log: errorLog(logs));
      } else if (error is FormatException) {
        logs.addAll({
          "message": error.message,
        });
        errorDialog(context, appConfig, AppLocalizations.of(context)!.parseError, log: errorLog(logs));
      } else if (error is SocketException) {
        logs.addAll({
          "message": error.message,
        });
        errorDialog(context, appConfig, AppLocalizations.of(context)!.socketException, log: errorLog(logs));
      } else {
        errorDialog(context, appConfig, AppLocalizations.of(context)!.unknownError, log: errorLog(logs));
      }
    });
  });
}

apiError(BuildContext context, AppConfig appConfig, dynamic error) {
  if (error is HttpException) {
    httpError(context, appConfig, error);
  } else {
    standardError(context, appConfig, error);
  }
}
