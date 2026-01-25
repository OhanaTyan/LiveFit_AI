import 'package:intl/intl.dart';

/// 日期时间工具类，提供各种日期时间处理功能
class DateTimeUtils {
  /// 格式化日期为指定格式
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  /// 格式化时间为指定格式
  static String formatTime(DateTime date, {String format = 'HH:mm'}) {
    return DateFormat(format).format(date);
  }

  /// 格式化日期时间为指定格式
  static String formatDateTime(DateTime date, {String format = 'yyyy-MM-dd HH:mm'}) {
    return DateFormat(format).format(date);
  }

  /// 获取今天的开始时间
  static DateTime getTodayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 获取今天的结束时间
  static DateTime getTodayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 获取本周的开始时间（周一）
  static DateTime getWeekStart() {
    final now = DateTime.now();
    final daysFromMonday = now.weekday - 1;
    return DateTime(now.year, now.month, now.day - daysFromMonday);
  }

  /// 获取本周的结束时间（周日）
  static DateTime getWeekEnd() {
    final weekStart = getWeekStart();
    return weekStart.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  /// 获取本月的开始时间
  static DateTime getMonthStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// 获取本月的结束时间
  static DateTime getMonthEnd() {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    return nextMonth.subtract(const Duration(seconds: 1));
  }

  /// 判断两个日期是否在同一天
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  /// 判断两个日期是否在同一周
  static bool isSameWeek(DateTime date1, DateTime date2) {
    final weekStart1 = getWeekStartForDate(date1);
    final weekStart2 = getWeekStartForDate(date2);
    return isSameDay(weekStart1, weekStart2);
  }

  /// 获取指定日期所在周的开始时间
  static DateTime getWeekStartForDate(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// 计算两个日期之间的天数差
  static int daysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  /// 计算两个时间之间的分钟差
  static int minutesBetween(DateTime startTime, DateTime endTime) {
    return endTime.difference(startTime).inMinutes;
  }

  /// 将分钟转换为小时和分钟的字符串表示
  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '$hours小时$mins分钟';
    } else {
      return '$mins分钟';
    }
  }

  /// 解析ISO格式的日期字符串
  static DateTime? parseIso8601(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 获取时间戳（秒）
  static int getTimestampSeconds() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// 从时间戳（秒）创建DateTime
  static DateTime fromTimestampSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
}
