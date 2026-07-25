import 'package:app_usage/app_usage.dart';

Future<List<AppUsageInfo>> getTopUsedAppsToday({int limit = 3}) async {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day); // midnight today

  List<AppUsageInfo> usageStats = await AppUsage().getAppUsage(startDate, endDate);

  // Filter out zero-usage entries (some system packages report 0 but still show up)
 // usageStats.removeWhere((app) => app.usage.inSeconds == 0);

  usageStats.sort((a, b) => b.usage.compareTo(a.usage)); // descending by duration

  return usageStats.take(limit).toList();
}