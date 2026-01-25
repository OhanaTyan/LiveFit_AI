import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';

class ScheduleConflict {
  final ScheduleEvent event1;
  final ScheduleEvent event2;
  final ConflictType type;
  final String description;

  ScheduleConflict({
    required this.event1,
    required this.event2,
    required this.type,
    required this.description,
  });
}

enum ConflictType {
  timeOverlap,
  priorityConflict,
  locationConflict,
}

class ScheduleConflictDetector {
  // 检测单个事件与事件列表的冲突 - 优化版
  List<ScheduleConflict> detectConflictsForEvent(
    ScheduleEvent newEvent,
    List<ScheduleEvent> existingEvents,
  ) {
    final conflicts = <ScheduleConflict>[];
    
    // 只检查可能与新事件冲突的事件（基于时间范围）
    // 首先过滤出时间范围可能重叠的事件，减少需要检查的事件数量
    final relevantEvents = existingEvents.where((event) {
      // 计算时间范围是否有重叠的可能
      return event.startTime.isBefore(newEvent.endTime) &&
             event.endTime.isAfter(newEvent.startTime) &&
             event.id != newEvent.id; // 跳过同一事件
    }).toList();
    
    // 并行检测不同类型的冲突
    for (final existingEvent in relevantEvents) {
      // 检测时间重叠冲突
      final timeConflict = _detectTimeOverlapConflict(newEvent, existingEvent);
      if (timeConflict != null) {
        conflicts.add(timeConflict);
      }
      
      // 检测优先级冲突
      final priorityConflict = _detectPriorityConflict(newEvent, existingEvent);
      if (priorityConflict != null) {
        conflicts.add(priorityConflict);
      }
      
      // 检测位置冲突
      final locationConflict = _detectLocationConflict(newEvent, existingEvent);
      if (locationConflict != null) {
        conflicts.add(locationConflict);
      }
    }
    
    return conflicts;
  }
  
  // 检测所有事件之间的冲突 - 优化版
  List<ScheduleConflict> detectAllConflicts(List<ScheduleEvent> events) {
    final conflicts = <ScheduleConflict>{}; // 使用Set避免重复冲突
    
    // 先按开始时间排序，减少需要检查的事件对
    final sortedEvents = List<ScheduleEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    for (var i = 0; i < sortedEvents.length; i++) {
      final event1 = sortedEvents[i];
      
      // 只检查开始时间在event1结束时间之前的事件
      // 因为事件已经排序，后面的事件开始时间如果大于等于event1结束时间，就不会有冲突
      for (var j = i + 1; j < sortedEvents.length; j++) {
        final event2 = sortedEvents[j];
        
        // 如果event2的开始时间已经大于等于event1的结束时间，后面的事件也不会有冲突
        if (event2.startTime.isAfter(event1.endTime) || 
            event2.startTime.isAtSameMomentAs(event1.endTime)) {
          break;
        }
        
        // 检测时间重叠冲突
        final timeConflict = _detectTimeOverlapConflict(event1, event2);
        if (timeConflict != null) {
          conflicts.add(timeConflict);
        }
        
        // 检测优先级冲突
        final priorityConflict = _detectPriorityConflict(event1, event2);
        if (priorityConflict != null) {
          conflicts.add(priorityConflict);
        }
        
        // 检测位置冲突
        final locationConflict = _detectLocationConflict(event1, event2);
        if (locationConflict != null) {
          conflicts.add(locationConflict);
        }
      }
    }
    
    return conflicts.toList();
  }
  
  // 检测时间重叠冲突 - 优化版
  ScheduleConflict? _detectTimeOverlapConflict(
    ScheduleEvent event1,
    ScheduleEvent event2,
  ) {
    // 快速检查是否有时间重叠
    final hasOverlap = event1.startTime.isBefore(event2.endTime) &&
        event1.endTime.isAfter(event2.startTime);
    
    if (hasOverlap) {
      // 计算重叠时间（分钟）
      final overlapStart = event1.startTime.isAfter(event2.startTime)
          ? event1.startTime
          : event2.startTime;
      final overlapEnd = event1.endTime.isBefore(event2.endTime)
          ? event1.endTime
          : event2.endTime;
      final overlapMinutes = overlapEnd.difference(overlapStart).inMinutes;
      
      // 只有当重叠时间超过5分钟时才视为冲突，提高检测灵敏度
      if (overlapMinutes > 5) {
        return ScheduleConflict(
          event1: event1,
          event2: event2,
          type: ConflictType.timeOverlap,
          description: '事件时间重叠 $overlapMinutes 分钟',
        );
      }
    }
    
    return null;
  }
  
  // 检测优先级冲突 - 优化版
  ScheduleConflict? _detectPriorityConflict(
    ScheduleEvent event1,
    ScheduleEvent event2,
  ) {
    // 快速检查时间重叠（已经在调用者中检查过，这里可以跳过，但保留作为防御性检查）
    final hasOverlap = event1.startTime.isBefore(event2.endTime) &&
        event1.endTime.isAfter(event2.startTime);
    
    if (hasOverlap) {
      // 简化优先级冲突检测逻辑
      final isHigherPriority = event1.priority.index > event2.priority.index;
      final isLowerPriority = event2.priority.index > event1.priority.index;
      
      if (isHigherPriority || isLowerPriority) {
        final higherPriorityEvent = isHigherPriority ? event1 : event2;
        final lowerPriorityEvent = isHigherPriority ? event2 : event1;
        
        return ScheduleConflict(
          event1: higherPriorityEvent,
          event2: lowerPriorityEvent,
          type: ConflictType.priorityConflict,
          description: '高优先级事件 "${higherPriorityEvent.title}" 与低优先级事件 "${lowerPriorityEvent.title}" 时间冲突',
        );
      }
    }
    
    return null;
  }
  
  // 检测位置冲突 - 优化版
  ScheduleConflict? _detectLocationConflict(
    ScheduleEvent event1,
    ScheduleEvent event2,
  ) {
    // 快速检查两个事件是否有时间重叠或接近
    final timeDifference = event1.endTime.difference(event2.startTime).inMinutes;
    const maxTimeGap = 45; // 最大时间间隔，超过这个值不视为位置冲突
    
    if (timeDifference.abs() > maxTimeGap) {
      return null; // 时间间隔太大，不可能有位置冲突
    }
    
    // 检查两个事件是否都有位置信息且位置不同
    if (event1.location != null &&
        event2.location != null &&
        event1.location != event2.location) {
      // 计算可用的切换时间
      final availableSwitchTime = timeDifference.abs();
      
      // 根据不同场景动态调整所需的切换时间
      int requiredSwitchTime;
      if (_isWorkEvent(event1.type) && _isWorkEvent(event2.type)) {
        requiredSwitchTime = 15; // 工作事件之间需要15分钟切换
      } else if (_isWorkoutEvent(event1.type) || _isWorkoutEvent(event2.type)) {
        requiredSwitchTime = 20; // 健身事件需要更多切换时间
      } else {
        requiredSwitchTime = 10; // 其他事件需要10分钟切换
      }
      
      if (availableSwitchTime < requiredSwitchTime) {
        return ScheduleConflict(
          event1: event1,
          event2: event2,
          type: ConflictType.locationConflict,
          description: '事件位置切换时间不足，仅 $availableSwitchTime 分钟，建议至少 $requiredSwitchTime 分钟',
        );
      }
    }
    
    return null;
  }
  
  // 辅助方法：检查是否为工作事件
  bool _isWorkEvent(EventType type) {
    return type == EventType.work;
  }
  
  // 辅助方法：检查是否为健身事件
  bool _isWorkoutEvent(EventType type) {
    return type == EventType.workout;
  }
  
  // 检测单个事件是否有冲突
  bool hasConflicts(
    ScheduleEvent newEvent,
    List<ScheduleEvent> existingEvents,
  ) {
    return detectConflictsForEvent(newEvent, existingEvents).isNotEmpty;
  }
  
  // 按冲突类型过滤冲突列表
  List<ScheduleConflict> filterConflictsByType(
    List<ScheduleConflict> conflicts,
    ConflictType type,
  ) {
    return conflicts.where((conflict) => conflict.type == type).toList();
  }
}
