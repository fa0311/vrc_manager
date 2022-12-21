import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:vrc_manager/widgets/share.dart';

class ConsoleOutputExt extends ConsoleOutput {
  List<OutputEventExt> state = [];
  @override
  void output(OutputEvent event) {
    OutputEventExt eventExt = OutputEventExt(event);
    super.output(eventExt);
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
    logger.v("Verbose log");
    logger.d("Debug log");
    logger.i("Info log");
    logger.w("Warning log");
    logger.e("Error log");
    logger.wtf("What a terrible failure log");

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.log),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                        openInBrowser(context, Uri.https("github.com", "/fa0311/vrc_manager/issues/new", {"template": "redirected-from-app.yml"}));
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
        ),
      ),
    );
  }
}
