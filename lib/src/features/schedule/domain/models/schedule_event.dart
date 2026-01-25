import 'package:flutter/material.dart';

enum EventType {
  workout,
  work,
  life,
  rest,
}

enum EventPriority {
  low,
  medium,
  high,
  urgent,
}

enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

class ScheduleEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final Color color;
  final bool isCompleted;
  final EventPriority priority;
  final String? location;
  final RecurrenceType recurrence;
  final DateTime? recurrenceEnd;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isStarred;
  
  // 星标状态对应的颜色
  Color get starredColor {
    if (!isStarred) return color;
    // 返回一个好看的星标颜色，例如金色
    return Colors.amber;
  }

  ScheduleEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.color,
    this.isCompleted = false,
    this.priority = EventPriority.medium,
    this.location,
    this.recurrence = RecurrenceType.none,
    this.recurrenceEnd,
    this.isDeleted = false,
    this.deletedAt,
    this.isStarred = false,
  });

  // Helper to get duration in minutes
  int get durationInMinutes => endTime.difference(startTime).inMinutes;

  // Helper to check if event is happening now
  bool isHappeningNow(DateTime now) {
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  // Helper to check if event is recurring
  bool get isRecurring => recurrence != RecurrenceType.none;

  // Helper to get next occurrence
  DateTime? getNextOccurrence(DateTime after) {
    if (!isRecurring) return null;
    
    var next = startTime;
    while (next.isBefore(after)) {
      switch (recurrence) {
        case RecurrenceType.daily:
          next = next.add(const Duration(days: 1));
          break;
        case RecurrenceType.weekly:
          next = next.add(const Duration(days: 7));
          break;
        case RecurrenceType.monthly:
          next = DateTime(next.year, next.month + 1, next.day);
          break;
        case RecurrenceType.yearly:
          next = DateTime(next.year + 1, next.month, next.day);
          break;
        default:
          return null;
      }
      
      if (recurrenceEnd != null && next.isAfter(recurrenceEnd!)) {
        return null;
      }
    }
    
    return next;
  }
}
