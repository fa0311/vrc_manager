String generalDateDifference(String time) {
  final DateTime parse = DateTime.parse(time);
  final Duration difference = DateTime.now().difference(parse);
  if (difference.inDays > 7) return "${parse.year}年${parse.month}月${parse.day}日";
  if (difference.inDays > 0) return "${difference.inDays}日${difference.inHours % 24}時間前";
  if (difference.inHours > 0) return "${difference.inHours}時間${difference.inMinutes % 60}分前";
  if (difference.inMinutes > 0) return "${difference.inMinutes}分前";
  return "${difference.inSeconds}秒前";
}
