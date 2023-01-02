// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/share.dart';

final loggerReportCounterProvider = StateProvider<int>((ref) => 0);

class ConsoleOutputExt extends ConsoleOutput {
  List<OutputEventExt> state = [];
  @override
  void output(OutputEvent event) {
    OutputEventExt eventExt = OutputEventExt(event);
    if (kDebugMode) super.output(eventExt);
    state.add(eventExt);
  }
}

class OutputEventExt extends OutputEvent {
  DateTime time = DateTime.now();
  OutputEventExt(OutputEvent event) : super(event.level, event.lines);
}

class LoggerReport extends ConsumerWidget {
  const LoggerReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loggerReportCounterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.log),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.read(loggerReportCounterProvider.notifier).state++,
          child: const ErrorPage(message: true),
        ),
      ),
    );
  }
}

class ErrorPage extends ConsumerWidget {
  final bool message;

  const ErrorPage({super.key, this.message = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);

    ref.watch(loggerReportCounterProvider);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          if (message)
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.reportMessage2),
              ),
            ),
          if (!message)
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.error),
                subtitle: Text([AppLocalizations.of(context)!.reportMessage1, AppLocalizations.of(context)!.reportMessage2].join('\n')),
              ),
            ),
          for (OutputEventExt state in loggerOutput.state.reversed)
            Card(
              child: ExpansionTile(
                title: Text(state.lines[state.lines.length - 2].replaceAll(RegExp(r'\u001b\[([0-9]|;)+m'), '').replaceAll('│ ', '')),
                subtitle: Text(generalDateDifference(context, state.time)),
                trailing: OutlinedButton(
                  child: Text(AppLocalizations.of(context)!.report),
                  onPressed: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                    BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
                    Map<String, dynamic> logs = {
                      "version": packageInfo.version,
                      "deviceInfo": deviceInfo.data,
                    };
                    JsonEncoder encoder = const JsonEncoder.withIndent("     ");
                    String text = encoder.convert(logs);
                    text += '\n';
                    text += state.lines.join('\n').replaceAll(RegExp(r'\u001b\[([0-9]|;)+m'), '');
                    await copyToClipboard(context, text);

                    Widget? value = await openInBrowser(
                      url: Assets.report,
                      forceExternal: accessibilityConfig.forceExternalBrowser,
                    );
                    if (value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => value),
                      );
                    }
                  },
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(state.lines.join('\n').replaceAll(RegExp(r'\u001b\[([0-9]|;)+m'), '')),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ErrorSnackBar extends ConsumerWidget {
  final dynamic status;
  const ErrorSnackBar(this.status, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VRChatError vrchatError;

    if (status is HttpException) {
      try {
        if (status.message.startsWith('<html>')) {
          vrchatError = VRChatError.fromHtml(status.message);
        } else {
          dynamic content = json.decode(status.message);
          if (kDebugMode) print(AnsiColor.fg(199)(content.toString()));
          try {
            vrchatError = VRChatError.fromJson(content);
          } catch (e) {
            return Text(otherError(context: context, content: content));
          }
        }
      } catch (e) {
        return Text(AppLocalizations.of(context)!.unknownError);
      }

      if (vrchatError.message == 'Too many requests') {
        return Text(AppLocalizations.of(context)!.tooManyRequests);
      } else if (vrchatError.message == '"Invalid Username/Email or Password"') {
        return Text(AppLocalizations.of(context)!.invalidLoginInfo);
      } else {
        return Text(vrchatError.message);
      }
    } else if (status is TypeError) {
      return Text(AppLocalizations.of(context)!.parseError);
    } else if (status is FormatException) {
      return Text(AppLocalizations.of(context)!.parseError);
    } else if (status is SocketException) {
      return Text(AppLocalizations.of(context)!.socketException);
    } else {
      return Text(AppLocalizations.of(context)!.unknownError);
    }
  }
}

String otherError({required BuildContext context, required dynamic content}) {
  try {
    VRChatLogin.fromJson(content);
    return AppLocalizations.of(context)!.incorrectLogin;
  } catch (e) {
    return AppLocalizations.of(context)!.unknownError;
  }
}

String getMessage(Object e) {
  return e.toString().split(':').first;
}
