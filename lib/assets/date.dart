// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String generalDateDifference(BuildContext context, String time) {
  final DateTime parse = DateTime.parse(time);
  final Duration difference = DateTime.now().difference(parse);
  if (difference.inDays > 7) return AppLocalizations.of(context)!.dateFormat1(parse.year, parse.month, parse.day);
  if (difference.inDays > 0) return AppLocalizations.of(context)!.dateFormat2(difference.inDays, difference.inHours % 24);
  if (difference.inHours > 0) return AppLocalizations.of(context)!.dateFormat3(difference.inHours, difference.inMinutes % 60);
  if (difference.inMinutes > 0) return AppLocalizations.of(context)!.dateFormat4(difference.inMinutes);
  return "${difference.inSeconds}秒前";
}
