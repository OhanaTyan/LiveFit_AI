import 'package:flutter/material.dart';
import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';
import 'package:life_fit/src/features/schedule/domain/services/schedule_conflict_detector.dart';
import 'package:life_fit/src/core/theme/app_colors.dart';

class ConflictResolutionDialog extends StatelessWidget {
  final ScheduleEvent newEvent;
  final List<ScheduleConflict> conflicts;
  final Function() onKeepExisting;
  final Function() onReplaceExisting;
  final Function() onAdjustTime;

  const ConflictResolutionDialog({
    Key? key,
    required this.newEvent,
    required this.conflicts,
    required this.onKeepExisting,
    required this.onReplaceExisting,
    required this.onAdjustTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '日程冲突',
        style: TextStyle(color: AppColors.error),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('检测到以下日程冲突：'),
            const SizedBox(height: 16),
            _buildConflictList(),
            const SizedBox(height: 16),
            _buildNewEventCard(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onKeepExisting,
          child: Text('保留现有日程'),
        ),
        TextButton(
          onPressed: onReplaceExisting,
          child: Text('替换现有日程', style: TextStyle(color: AppColors.error)),
        ),
        ElevatedButton(
          onPressed: onAdjustTime,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: Text('调整时间'),
        ),
      ],
    );
  }

  Widget _buildConflictList() {
    return Column(
      children: conflicts.map((conflict) {
        final existingEvent = conflict.event1.id == newEvent.id ? conflict.event2 : conflict.event1;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 24,
                      color: existingEvent.color,
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    Expanded(
                      child: Text(
                        existingEvent.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTimeRange(existingEvent),
                if (existingEvent.location != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      existingEvent.location!, 
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    conflict.description,
                    style: TextStyle(fontSize: 12, color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNewEventCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 24,
                  color: newEvent.color,
                  margin: const EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: Text(
                    '新事件',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTimeRange(newEvent),
            if (newEvent.location != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  newEvent.location!, 
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '您的新日程与现有日程冲突，请选择解决方式',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRange(ScheduleEvent event) {
    final startTimeStr = '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr = '${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}';
    final dateStr = '${event.startTime.year}-${event.startTime.month.toString().padLeft(2, '0')}-${event.startTime.day.toString().padLeft(2, '0')}';
    
    return Row(
      children: [
        Icon(Icons.access_time, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          '$dateStr $startTimeStr - $endTimeStr',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

// 冲突解决结果枚举
enum ConflictResolutionResult {
  keepExisting,
  replaceExisting,
  adjustTime,
}
