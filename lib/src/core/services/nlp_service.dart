import 'package:flutter/material.dart';
import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';

class NlpService {
  // Extract schedule events from text
  List<Map<String, dynamic>> extractScheduleEvents(String text) {
    final events = <Map<String, dynamic>>[];
    
    // Split text into sentences
    final sentences = text.split(RegExp(r'[。！？]')).where((s) => s.isNotEmpty).toList();
    
    for (var sentence in sentences) {
      final event = _parseSingleEvent(sentence);
      if (event != null) {
        events.add(event);
      }
    }
    
    return events;
  }
  
  Map<String, dynamic>? _parseSingleEvent(String text) {
    // Simple rule-based parsing for demonstration
    // In a real app, this would use a more sophisticated NLP approach
    
    final event = <String, dynamic>{};
    
    // Extract title
    final titleMatch = RegExp(r'安排|计划|预约|参加|召开|锻炼|运动|健身|训练|会议')
        .firstMatch(text);
    
    if (titleMatch != null) {
      String title = text.substring(titleMatch.start);
      // Clean up title
      title = title.replaceAll(RegExp(r'[^一-龥a-zA-Z0-9]'), ' ').trim();
      event['title'] = title;
    } else {
      event['title'] = '未命名事件';
    }
    
    // Extract time
    final timeInfo = _extractTime(text);
    event.addAll(timeInfo);
    
    // Extract location
    final location = _extractLocation(text);
    event['location'] = location;
    
    // Extract description
    event['description'] = text;
    
    // Extract priority (simple rule)
    if (text.contains('重要') || text.contains('紧急')) {
      event['priority'] = 'high';
    } else if (text.contains('普通') || text.contains('常规')) {
      event['priority'] = 'medium';
    } else {
      event['priority'] = 'low';
    }
    
    return event;
  }
  
  Map<String, dynamic> _extractTime(String text) {
    final timeInfo = <String, dynamic>{};
    final now = DateTime.now();
    
    // Handle tomorrow
    if (text.contains('明天')) {
      final tomorrow = now.add(const Duration(days: 1));
      timeInfo['startTime'] = tomorrow;
      timeInfo['endTime'] = tomorrow.add(const Duration(hours: 1));
      return timeInfo;
    }
    
    // Handle next week
    if (text.contains('下周')) {
      final nextWeek = now.add(const Duration(days: 7));
      timeInfo['startTime'] = nextWeek;
      timeInfo['endTime'] = nextWeek.add(const Duration(hours: 1));
      return timeInfo;
    }
    
    // Handle specific time format like "下午3点" or "15:00"
    final timeMatch = RegExp(r'(上午|下午)?\s*(\d{1,2})([:：]\d{2})?\s*(点|分)?')
        .firstMatch(text);
    
    if (timeMatch != null) {
      final isAfternoon = timeMatch.group(1) == '下午';
      int hour = int.parse(timeMatch.group(2)!);
      int minute = timeMatch.group(3) != null ? int.parse(timeMatch.group(3)!.substring(1)) : 0;
      
      if (isAfternoon && hour < 12) {
        hour += 12;
      }
      
      final date = DateTime(now.year, now.month, now.day, hour, minute);
      timeInfo['startTime'] = date;
      timeInfo['endTime'] = date.add(const Duration(hours: 1));
      return timeInfo;
    }
    
    // Handle duration
    final durationMatch = RegExp(r'(\d+)\s*(小时|分钟|分)').firstMatch(text);
    if (durationMatch != null) {
      final duration = int.parse(durationMatch.group(1)!);
      final unit = durationMatch.group(2);
      
      Duration durationObj;
      if (unit == '小时') {
        durationObj = Duration(hours: duration);
      } else {
        durationObj = Duration(minutes: duration);
      }
      
      if (timeInfo.containsKey('startTime')) {
        timeInfo['endTime'] = timeInfo['startTime'].add(durationObj);
      }
    }
    
    // Default to now if no time extracted
    if (!timeInfo.containsKey('startTime')) {
      timeInfo['startTime'] = now;
      timeInfo['endTime'] = now.add(const Duration(hours: 1));
    }
    
    return timeInfo;
  }
  
  String _extractLocation(String text) {
    // Simple location extraction
    final locationPatterns = [
      RegExp(r'在(\w+)'),
      RegExp(r'于(\w+)'),
      RegExp(r'(会议室|办公室|健身房|操场|公园|餐厅|酒店)\s*[A-Za-z0-9]*'),
      RegExp(r'[市县区路街道号]\s*\w+'),
    ];
    
    for (var pattern in locationPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0)!.replaceAll(RegExp(r'^[在于]'), '');
      }
    }
    
    return '未指定地点';
  }
  
  // Check for ambiguous information
  List<String> checkAmbiguity(Map<String, dynamic> event) {
    final ambiguities = <String>[];
    
    // Check time ambiguity
    if (event['startTime'] == null) {
      ambiguities.add('time');
    }
    
    // Check location ambiguity
    if (event['location'] == null || event['location'] == '未指定地点') {
      ambiguities.add('location');
    }
    
    // Check title ambiguity
    if (event['title'] == null || event['title'] == '未命名事件') {
      ambiguities.add('title');
    }
    
    return ambiguities;
  }
  
  // Convert extracted event to ScheduleEvent model
  ScheduleEvent toScheduleEvent(Map<String, dynamic> extractedEvent) {
    // Parse start time
    DateTime startTime;
    if (extractedEvent['startTime'] is DateTime) {
      startTime = extractedEvent['startTime'];
    } else if (extractedEvent['startTime'] is String) {
      try {
        startTime = DateTime.parse(extractedEvent['startTime']);
      } catch (e) {
        startTime = DateTime.now();
      }
    } else {
      startTime = DateTime.now();
    }

    // Parse end time
    DateTime endTime;
    if (extractedEvent['endTime'] is DateTime) {
      endTime = extractedEvent['endTime'];
    } else if (extractedEvent['endTime'] is String) {
      try {
        endTime = DateTime.parse(extractedEvent['endTime']);
      } catch (e) {
        endTime = startTime.add(const Duration(hours: 1));
      }
    } else {
      endTime = startTime.add(const Duration(hours: 1));
    }

    // Parse type
    EventType type;
    if (extractedEvent['type'] is String) {
      try {
        type = EventType.values.firstWhere(
          (e) => e.name == extractedEvent['type'],
          orElse: () => _determineEventType(extractedEvent['title'] ?? ''),
        );
      } catch (e) {
        type = _determineEventType(extractedEvent['title'] ?? '');
      }
    } else {
      type = _determineEventType(extractedEvent['title'] ?? '');
    }

    // Parse priority
    EventPriority priority = EventPriority.medium;
    if (extractedEvent['priority'] is String) {
      try {
        priority = EventPriority.values.firstWhere(
          (e) => e.name == extractedEvent['priority'],
          orElse: () => EventPriority.medium,
        );
      } catch (e) {
        priority = EventPriority.medium;
      }
    }

    return ScheduleEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: extractedEvent['title'] ?? '未命名事件',
      description: extractedEvent['description'] ?? '',
      startTime: startTime,
      endTime: endTime,
      type: type,
      color: _getColorForType(type),
      isCompleted: false,
      priority: priority,
      location: extractedEvent['location'],
    );
  }

  Color _getColorForType(EventType type) {
    switch (type) {
      case EventType.work:
        return Colors.blue;
      case EventType.workout:
        return Colors.green;
      case EventType.rest:
        return Colors.orange;
      case EventType.life:
      default:
        return Colors.pinkAccent;
    }
  }
  
  EventType _determineEventType(String title) {
    if (title.contains('会议') || title.contains('讨论') || title.contains('汇报')) {
      return EventType.work;
    } else if (title.contains('锻炼') || title.contains('运动') || title.contains('健身') || title.contains('训练')) {
      return EventType.workout;
    } else if (title.contains('休息') || title.contains('放松') || title.contains('娱乐')) {
      return EventType.rest;
    } else {
      return EventType.life;
    }
  }
  
  Color _getColorForEventType(String title) {
    if (title.contains('会议') || title.contains('讨论') || title.contains('汇报')) {
      return Colors.blue;
    } else if (title.contains('锻炼') || title.contains('运动') || title.contains('健身') || title.contains('训练')) {
      return Colors.green;
    } else if (title.contains('休息') || title.contains('放松') || title.contains('娱乐')) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }
  
  // 生成澄清问题
  String generateClarificationQuestion(String ambiguityType, Map<String, dynamic> schedule) {
    switch (ambiguityType) {
      case 'title':
        return '请问这个日程的具体标题是什么？';
      case 'time':
        return '请问这个日程是安排在什么时候？';
      case 'location':
        return '请问这个日程的地点在哪里？';
      default:
        return '请问您能补充一下这个日程的更多信息吗？';
    }
  }
}