import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';
import 'package:life_fit/src/features/schedule/presentation/widgets/event_card.dart';
import 'package:life_fit/src/features/schedule/presentation/widgets/empty_schedule_view.dart';
import 'package:life_fit/src/core/theme/app_colors.dart';

class TimelineView extends StatelessWidget {
  final List<ScheduleEvent> events;
  final Function(ScheduleEvent)? onEventTap;
  final Function(ScheduleEvent)? onEventLongPress;
  final Function(ScheduleEvent)? onStarTap;
  final bool isMultiSelectMode;
  final List<String> selectedEventIds;

  const TimelineView({
    super.key,
    required this.events,
    this.onEventTap,
    this.onEventLongPress,
    this.onStarTap,
    this.isMultiSelectMode = false,
    this.selectedEventIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (events.isEmpty) {
      return const EmptyScheduleView();
    }

    // Sort events by time
    final sortedEvents = List<ScheduleEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), // Bottom padding for FAB
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        final isLast = index == sortedEvents.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Timeline Column
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(event.startTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Dot - 使用星标颜色
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: event.starredColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                      width: 2,
                    ),
                        boxShadow: [
                          BoxShadow(
                            color: event.starredColor.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    // Line
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.textDisabled.withValues(alpha: 0.2),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                  ],
                ),
              ),
              
              // 2. Content Card
              Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: EventCard(
                  event: event,
                  onTap: () => onEventTap?.call(event),
                  onLongPress: () => onEventLongPress?.call(event),
                  onStarTap: () => onStarTap?.call(event),
                  isSelected: selectedEventIds.contains(event.id),
                ),
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }
}
