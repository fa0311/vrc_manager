// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String generalDateDifference(BuildContext context, DateTime time) {
  final Duration difference = DateTime.now().difference(time);
  if (difference.inDays > 7) return DateFormat.yMMMMd(AppLocalizations.of(context)!.localeName).format(time);
  if (difference.inDays > 0) return AppLocalizations.of(context)!.dateFormat1(difference.inDays, difference.inHours % 24);
  if (difference.inHours > 0) return AppLocalizations.of(context)!.dateFormat2(difference.inHours, difference.inMinutes % 60);
  if (difference.inMinutes > 0) return AppLocalizations.of(context)!.dateFormat3(difference.inMinutes);
  return AppLocalizations.of(context)!.dateFormat3(difference.inSeconds);
}
