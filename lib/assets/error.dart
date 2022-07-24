// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

void errorDialog(BuildContext context, String text, {String log = ""}) {
  if (log.isNotEmpty) {
    text += "\n${AppLocalizations.of(context)!.reportMessage1}\n${AppLocalizations.of(context)!.reportMessage2(AppLocalizations.of(context)!.report)}";
  }
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
                onPressed: () {
                  ClipboardData data = ClipboardData(text: log);
                  Clipboard.setData(data).then(
                    (_) {
                      if (Platform.isAndroid || Platform.isIOS) {
                        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.copied);
                      }
                      openInBrowser(context, "https://github.com/fa0311/vrchat_mobile_client/issues/new/choose");
                    },
                  );
                }),
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}

String errorLog(Map log) {
  JsonEncoder encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(log);
}

httpError(BuildContext context, HttpException error) {
  try {
    dynamic message = json.decode(error.message);
    VRChatError content = VRChatError.fromJson(message);
    if (content.message == '"Missing Credentials"') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobileLogin(),
        ),
        (_) => false,
      );
    } else if (content.message == 'Too many requests') {
      errorDialog(context, AppLocalizations.of(context)!.tooManyRequests);
    } else if (content.message == '"Invalid Username/Email or Password"') {
      errorDialog(context, AppLocalizations.of(context)!.invalidLoginInfo);
    } else {
      if (kDebugMode) {
        print(content.message);
      }
      errorDialog(context, content.message);
    }
  } catch (e) {
    standardError(context, e);
    return;
  }
}

standardError(BuildContext context, dynamic error) {
  if (kDebugMode) {
    print(error.stackTrace);
  }
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfoPlugin.deviceInfo.then((BaseDeviceInfo deviceInfo) {
      String log = errorLog({
        "version": packageInfo.version,
        "deviceInfo": deviceInfo.toMap(),
        "error": error.toString(),
        "stackTrace": (error.stackTrace ?? "").toString(),
      });
      if (error is TypeError) {
        errorDialog(context, AppLocalizations.of(context)!.parseError, log: log);
      } else if (error is FormatException) {
        errorDialog(context, AppLocalizations.of(context)!.parseError, log: log);
      } else if (error is SocketException) {
        errorDialog(context, AppLocalizations.of(context)!.socketException, log: log);
      } else {
        errorDialog(context, AppLocalizations.of(context)!.unknownError, log: log);
      }
    });
  });
}

apiError(BuildContext context, dynamic error) {
  if (error is HttpException) {
    httpError(context, error);
  } else {
    standardError(context, error);
  }
}

otherError(BuildContext context, String text, {Map? content}) {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfoPlugin.deviceInfo.then((BaseDeviceInfo deviceInfo) {
      String log = errorLog({
        "version": packageInfo.version,
        "deviceInfo": deviceInfo.toMap(),
        "content": content,
      });
      errorDialog(context, text, log: log);
    });
  });
}
