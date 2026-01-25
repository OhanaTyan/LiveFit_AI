import '../../features/schedule/domain/models/schedule_event.dart';

// 时间间隙模型
class TimeGap {
  final DateTime start;
  final DateTime end;
  final Duration duration;
  final String type;
  final ScheduleEvent? previousEvent;
  final ScheduleEvent? nextEvent;
  
  TimeGap({
    required this.start,
    required this.end,
    required this.duration,
    required this.type,
    this.previousEvent,
    this.nextEvent,
  });
}

class ScheduleAnalysisService {
  static ScheduleAnalysisService? _instance;
  
  factory ScheduleAnalysisService() {
    _instance ??= ScheduleAnalysisService._internal();
    return _instance!;
  }
  
  ScheduleAnalysisService._internal();
  
  // 分析日程并识别时间间隙
  List<TimeGap> identifyTimeGaps(List<ScheduleEvent> events, {DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    final gaps = <TimeGap>[];
    
    // 过滤并排序相关事件
    final relevantEvents = events
        .where((event) => event.startTime.isAfter(currentTime.subtract(const Duration(days: 1))))
        .toList();
    
    // 按开始时间排序
    relevantEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // 检查当前时间到第一个事件的间隙
    if (relevantEvents.isNotEmpty) {
      final firstEvent = relevantEvents.first;
      if (currentTime.isBefore(firstEvent.startTime)) {
        final gapDuration = firstEvent.startTime.difference(currentTime);
        if (gapDuration.inMinutes > 5) {
          gaps.add(TimeGap(
            start: currentTime,
            end: firstEvent.startTime,
            duration: gapDuration,
            type: 'before_first_event',
            nextEvent: firstEvent,
          ));
        }
      }
    }
    
    // 检查事件之间的间隙
    for (int i = 0; i < relevantEvents.length - 1; i++) {
      final currentEvent = relevantEvents[i];
      final nextEvent = relevantEvents[i + 1];
      
      if (currentEvent.endTime.isBefore(nextEvent.startTime)) {
        final gapDuration = nextEvent.startTime.difference(currentEvent.endTime);
        if (gapDuration.inMinutes > 5) {
          gaps.add(TimeGap(
            start: currentEvent.endTime,
            end: nextEvent.startTime,
            duration: gapDuration,
            type: 'between_events',
            previousEvent: currentEvent,
            nextEvent: nextEvent,
          ));
        }
      }
    }
    
    // 检查最后一个事件之后的间隙
    if (relevantEvents.isNotEmpty) {
      final lastEvent = relevantEvents.last;
      final todayEnd = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        23,
        59,
        59,
      );
      
      if (lastEvent.endTime.isBefore(todayEnd)) {
        final gapDuration = todayEnd.difference(lastEvent.endTime);
        if (gapDuration.inMinutes > 30) {
          gaps.add(TimeGap(
            start: lastEvent.endTime,
            end: todayEnd,
            duration: gapDuration,
            type: 'after_last_event',
            previousEvent: lastEvent,
          ));
        }
      }
    }
    
    return gaps;
  }
  
  // 分析日程密度
  Map<String, dynamic> analyzeScheduleDensity(List<ScheduleEvent> events, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    final startOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final endOfDay = DateTime(targetDate.year, targetDate.month, targetDate.day, 23, 59, 59);
    
    // 过滤当天的事件
    final dayEvents = events.where((event) {
      final eventStart = event.startTime;
      return eventStart.isAfter(startOfDay) && eventStart.isBefore(endOfDay);
    }).toList();
    
    // 计算总占用时间
    final totalOccupiedMinutes = dayEvents.fold(0, (sum, event) {
      final eventStart = event.startTime.isAfter(startOfDay) ? event.startTime : startOfDay;
      final eventEnd = event.endTime.isBefore(endOfDay) ? event.endTime : endOfDay;
      return sum + eventEnd.difference(eventStart).inMinutes;
    });
    
    // 计算总可用时间（假设16小时工作日）
    const totalAvailableMinutes = 16 * 60;
    
    // 计算密度百分比
    final densityPercentage = (totalOccupiedMinutes / totalAvailableMinutes) * 100;
    
    // 分类密度
    String densityLevel;
    if (densityPercentage < 30) {
      densityLevel = 'light';
    } else if (densityPercentage < 60) {
      densityLevel = 'moderate';
    } else if (densityPercentage < 85) {
      densityLevel = 'heavy';
    } else {
      densityLevel = 'extreme';
    }
    
    // 分析事件分布
    final hourlyDistribution = <int, int>{};
    for (int hour = 0; hour < 24; hour++) {
      hourlyDistribution[hour] = 0;
    }
    
    for (final event in dayEvents) {
      final startHour = event.startTime.hour;
      final endHour = event.endTime.hour;
      
      for (int hour = startHour; hour <= endHour && hour < 24; hour++) {
        hourlyDistribution[hour] = (hourlyDistribution[hour] ?? 0) + 1;
      }
    }
    
    // 找出最忙和最空闲的时段
    int busiestHour = 0;
    int highestCount = 0;
    int freeHour = 0;
    int lowestCount = 999;
    
    hourlyDistribution.forEach((hour, count) {
      if (count > highestCount) {
        highestCount = count;
        busiestHour = hour;
      }
      if (count < lowestCount) {
        lowestCount = count;
        freeHour = hour;
      }
    });
    
    return {
      'totalEvents': dayEvents.length,
      'totalOccupiedMinutes': totalOccupiedMinutes,
      'densityPercentage': densityPercentage,
      'densityLevel': densityLevel,
      'hourlyDistribution': hourlyDistribution,
      'busiestHour': busiestHour,
      'freeHour': freeHour,
      'eventTypes': _analyzeEventTypes(dayEvents),
    };
  }
  
  // 分析事件类型分布
  Map<String, int> _analyzeEventTypes(List<ScheduleEvent> events) {
    final typeCounts = <String, int>{};
    
    for (final event in events) {
      final typeName = event.type.toString().split('.').last;
      typeCounts[typeName] = (typeCounts[typeName] ?? 0) + 1;
    }
    
    return typeCounts;
  }
  
  // 预测未来日程负载
  Map<String, dynamic> predictFutureLoad(List<ScheduleEvent> events, {int days = 7}) {
    final now = DateTime.now();
    final predictions = <String, dynamic>{};
    
    for (int i = 0; i < days; i++) {
      final targetDate = now.add(Duration(days: i));
      final dayAnalysis = analyzeScheduleDensity(events, date: targetDate);
      
      predictions[targetDate.toIso8601String().split('T').first] = {
        'densityLevel': dayAnalysis['densityLevel'],
        'totalEvents': dayAnalysis['totalEvents'],
        'densityPercentage': dayAnalysis['densityPercentage'],
      };
    }
    
    return predictions;
  }
  
  // 查找最佳活动时间
  List<TimeGap> findOptimalActivityTimes(List<ScheduleEvent> events, {
    required int minimumDurationMinutes,
    DateTime? startFrom,
    DateTime? endAt,
  }) {
    final startTime = startFrom ?? DateTime.now();
    final endTime = endAt ?? startTime.add(const Duration(days: 3));
    
    // 识别所有时间间隙
    final allGaps = identifyTimeGaps(events, now: startTime);
    
    // 过滤符合条件的间隙
    final optimalGaps = allGaps.where((gap) {
      return gap.duration.inMinutes >= minimumDurationMinutes &&
             gap.start.isBefore(endTime) &&
             gap.end.isAfter(startTime);
    }).toList();
    
    // 按间隙长度排序（从长到短）
    optimalGaps.sort((a, b) => b.duration.compareTo(a.duration));
    
    return optimalGaps;
  }
  
  // 分析用户活动模式
  Map<String, dynamic> analyzeUserPatterns(List<ScheduleEvent> events) {
    final now = DateTime.now();
    final pastEvents = events.where((event) => event.endTime.isBefore(now)).toList();
    
    if (pastEvents.isEmpty) {
      return {
        'workoutFrequency': 0,
        'averageWorkDuration': 0,
        'preferredActivityTimes': [],
        'activityBalance': 'insufficient_data',
      };
    }
    
    // 计算锻炼频率
    final workoutEvents = pastEvents.where((event) => event.type == EventType.workout).length;
    final daysSinceFirstEvent = (now.difference(pastEvents.first.startTime).inDays).abs();
    final workoutFrequency = daysSinceFirstEvent > 0 ? workoutEvents / daysSinceFirstEvent : 0;
    
    // 计算平均工作时长
    final workEvents = pastEvents.where((event) => event.type == EventType.work);
    final totalWorkMinutes = workEvents.fold(0, (sum, event) => sum + event.durationInMinutes);
    final averageWorkDuration = workEvents.isNotEmpty ? totalWorkMinutes / workEvents.length : 0;
    
    // 分析偏好活动时间
    final activityHourCounts = <int, int>{};
    for (int hour = 0; hour < 24; hour++) {
      activityHourCounts[hour] = 0;
    }
    
    for (final event in pastEvents) {
      final hour = event.startTime.hour;
      activityHourCounts[hour] = (activityHourCounts[hour] ?? 0) + 1;
    }
    
    // 找出偏好的活动时间
    final sortedHours = activityHourCounts.entries
        .where((entry) => entry.value > 0)
        .toList()..sort((a, b) => b.value.compareTo(a.value));
    
    final preferredActivityTimes = sortedHours.take(3).map((entry) => entry.key).toList();
    
    // 分析活动平衡
    final typeCounts = _analyzeEventTypes(pastEvents);
    final totalEvents = pastEvents.length;
    
    String activityBalance;
    if (typeCounts['workout'] != null && typeCounts['workout']! / totalEvents > 0.2) {
      if (typeCounts['rest'] != null && typeCounts['rest']! / totalEvents > 0.1) {
        activityBalance = 'balanced';
      } else {
        activityBalance = 'active_but_no_rest';
      }
    } else if (typeCounts['work'] != null && typeCounts['work']! / totalEvents > 0.6) {
      activityBalance = 'work_heavy';
    } else {
      activityBalance = 'needs_improvement';
    }
    
    return {
      'workoutFrequency': workoutFrequency,
      'averageWorkDuration': averageWorkDuration,
      'preferredActivityTimes': preferredActivityTimes,
      'activityBalance': activityBalance,
      'typeDistribution': typeCounts,
    };
  }
}
