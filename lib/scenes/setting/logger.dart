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
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/scroll.dart';
import 'package:vrc_manager/widgets/share.dart';

final loggerReportProvider = StateProvider<Iterable<OutputEventExt>>((ref) => loggerOutput.state.reversed);
final loggerFilterProvider = StateProvider<List<Level>>((ref) => [Level.error, Level.info]);

class LoggerExt extends Logger {
  static Level level = Level.verbose;
  final LogFilter _filter;
  final LogPrinter _printer;
  final LogOutput _output;

  LoggerExt({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
  })  : _filter = filter ?? DevelopmentFilter(),
        _printer = printer ?? PrettyPrinter(),
        _output = output ?? ConsoleOutput(),
        super(filter: AlwaysHiddenFilter()) {
    _filter.init();
    _filter.level = level ?? Logger.level;
    _printer.init();
    _output.init();
  }

  @override
  void log(Level level, dynamic message, [dynamic error, StackTrace? stackTrace]) {
    super.log(level, message, error, stackTrace);
    final logEvent = LogEvent(level, message, error, stackTrace);
    final output = _printer.log(logEvent);
    if (output.isNotEmpty) {
      var outputEvent = OutputEventExt(logEvent, output, message, error, stackTrace);
      _output.output(outputEvent);
    }
  }
}

class AlwaysHiddenFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}

class ConsoleOutputExt extends ConsoleOutput {
  List<OutputEventExt> state = [];
  @override
  void output(OutputEvent event) {
    if (kDebugMode) super.output(event);
    state.add(event as OutputEventExt);
  }
}

class OutputEventExt extends OutputEvent {
  final dynamic message;
  final dynamic error;
  final StackTrace? stackTrace;
  final DateTime time = DateTime.now();

  OutputEventExt(super.level, super.lines, this.message, this.error, this.stackTrace);
}

class LoggerReport extends ConsumerWidget {
  const LoggerReport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Iterable<OutputEventExt> log = ref.watch(loggerReportProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.log),
      ),
      body: SafeArea(
        child: ScrollWidget(
          onRefresh: () async => ref.refresh(loggerReportProvider.notifier),
          child: ErrorPage(
            loggerReport: log,
            title: Text(AppLocalizations.of(context)!.reportMessage2),
            hiddenSubtitle: true,
          ),
        ),
      ),
    );
  }
}

class ErrorPage extends ConsumerWidget {
  final Iterable<OutputEventExt> loggerReport;
  final Widget? title;
  final Widget? subtitle;
  final bool hiddenSubtitle;
  final bool hiddenTitle;

  const ErrorPage({
    super.key,
    required this.loggerReport,
    this.title,
    this.subtitle,
    this.hiddenTitle = false,
    this.hiddenSubtitle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    List<Level> loggerFilter = ref.watch(loggerFilterProvider);

    return Column(
      children: [
        Card(
          child: ListTile(
            title: hiddenTitle ? null : title ?? Text(AppLocalizations.of(context)!.error),
            subtitle: hiddenSubtitle
                ? null
                : subtitle ??
                    Text([
                      AppLocalizations.of(context)!.reportMessage1,
                      AppLocalizations.of(context)!.reportMessage2,
                    ].join('\n')),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showModalBottomSheetConsumer(
                  context: context,
                  builder: (context, ref, child) {
                    List<Level> loggerFilter = ref.watch(loggerFilterProvider);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(AppLocalizations.of(context)!.viewDetailedLogs),
                            onChanged: (bool value) {
                              if (!loggerFilter.remove(Level.warning)) loggerFilter.add(Level.warning);
                              ref.read(loggerFilterProvider.notifier).state = [...loggerFilter];
                            },
                            value: loggerFilter.contains(Level.warning),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
        for (OutputEventExt state in loggerReport.where((e) => loggerFilter.contains(e.level)))
          Card(
            child: ExpansionTile(
              title: Text((PrettyPrinter.levelEmojis[state.level] ?? "") + errorMessage(context: context, status: state.error)),
              subtitle: Text(generalDateDifference(context, state.time)),
              trailing: OutlinedButton(
                child: Text(AppLocalizations.of(context)!.report),
                onPressed: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                  BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
                  Map<String, dynamic> logs = {
                    "appName": packageInfo.appName,
                    "buildNumber": packageInfo.buildNumber,
                    "buildSignature": packageInfo.buildSignature,
                    "installerStore": packageInfo.installerStore,
                    "packageName": packageInfo.packageName,
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
    );
  }
}

String errorMessage({required BuildContext context, dynamic status}) {
  String otherError({required dynamic content}) {
    try {
      VRChatLogin.fromJson(content);
      return AppLocalizations.of(context)!.incorrectLogin;
    } catch (e) {
      return AppLocalizations.of(context)!.unknownError;
    }
  }

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
          return otherError(content: content);
        }
      }
    } catch (e) {
      return AppLocalizations.of(context)!.unknownError;
    }

    if (vrchatError.message == 'Too many requests') {
      return AppLocalizations.of(context)!.tooManyRequests;
    } else if (vrchatError.message == '"Invalid Username/Email or Password"') {
      return AppLocalizations.of(context)!.invalidLoginInfo;
    } else {
      return vrchatError.message;
    }
  } else if (status is TypeError) {
    return AppLocalizations.of(context)!.parseError;
  } else if (status is FormatException) {
    return AppLocalizations.of(context)!.parseError;
  } else if (status is SocketException) {
    return AppLocalizations.of(context)!.socketException;
  } else {
    return AppLocalizations.of(context)!.unknownError;
  }
}

String getMessage(Object e) {
  return e.toString().split(':').first;
}
