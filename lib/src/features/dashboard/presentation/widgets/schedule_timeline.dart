import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../schedule/domain/models/schedule_event.dart';
import '../../../../core/localization/app_localizations.dart';

class ScheduleTimeline extends StatelessWidget {
  final List<ScheduleEvent> events;

  const ScheduleTimeline({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context);
    
    if (l10n == null) {
      return const SizedBox();
    }
    
    // 筛选出今天的事件并排序
    final todayEvents = events
        .where((event) => 
            !event.isDeleted &&
            event.startTime.year == now.year && 
            event.startTime.month == now.month && 
            event.startTime.day == now.day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    // 确定下一个事件的索引
    int nextEventIndex = -1;
    for (int i = 0; i < todayEvents.length; i++) {
      if (todayEvents[i].startTime.isAfter(now)) {
        nextEventIndex = i;
        break;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.todaySchedule,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.brightness == Brightness.dark ? AppColors.textPrimary : AppColors.textPrimaryLight,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          
          // 如果没有今日日程，显示空状态
          if (todayEvents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  l10n.noScheduleToday,
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            // 构建时间线项目
            for (int i = 0; i < todayEvents.length; i++)
              _buildTimelineItem(
                context,
                event: todayEvents[i],
                isNext: i == nextEventIndex,
                showLine: i < todayEvents.length - 1,
              ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required ScheduleEvent event,
    bool isNext = false,
    bool showLine = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // 计算事件时长
    final duration = event.endTime.difference(event.startTime);
    final durationText = duration.inMinutes >= 60 
        ? '${duration.inHours}小时${duration.inMinutes % 60}分钟'
        : '${duration.inMinutes}分钟';
    
    // 格式化时间
    final timeText = DateFormat('HH:mm').format(event.startTime);
    
    // 根据事件类型设置图标和颜色
    IconData icon;
    Color itemColor;
    
    switch (event.type) {
      case EventType.workout:
        icon = Icons.fitness_center;
        itemColor = AppColors.primary;
        break;
      case EventType.work:
        icon = Icons.work;
        itemColor = AppColors.secondary;
        break;
      case EventType.life:
        icon = Icons.coffee;
        itemColor = AppColors.secondary;
        break;
      case EventType.rest:
        icon = Icons.bed;
        itemColor = AppColors.primary;
        break;
    }
    
    final textColor = isDark ? AppColors.textPrimary : AppColors.textPrimaryLight;
    
    // 使用星标颜色（如果事件已星标）
    final displayColor = event.isStarred ? event.starredColor : itemColor;
    
    // 星标事件的突出显示效果
    final isStarred = event.isStarred;
    final shouldHighlight = isStarred || isNext;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column - 使用自适应宽度
          SizedBox(
            width: 64, // 减小固定宽度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: shouldHighlight ? displayColor : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  durationText,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textDisabled : AppColors.textDisabled,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // 减小间距
          // Timeline Line
          Column(
            children: [
              Container(
                width: 16, // 增大尺寸
                height: 16,
                decoration: BoxDecoration(
                  color: shouldHighlight ? displayColor : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  border: Border.all(
                    color: displayColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: displayColor.withValues(alpha: 0.4),
                      blurRadius: 6, // 增大阴影
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                // 星标事件显示星形图标
                child: isStarred ? const Icon(
                  Icons.star,
                  size: 10,
                  color: Colors.white,
                ) : null,
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 4),
                    color: isDark ? AppColors.surfaceDark : AppColors.borderLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12), // 减小间距
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16), // 增大内边距
              decoration: BoxDecoration(
                color: shouldHighlight 
                    ? displayColor.withValues(alpha: 0.15) // 更明显的背景色
                    : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                borderRadius: BorderRadius.circular(14), // 更大的圆角
                border: Border.all(
                  color: shouldHighlight ? displayColor.withValues(alpha: 0.5) : Colors.transparent,
                  width: 2, // 更粗的边框
                ),
                boxShadow: [
                  BoxShadow(
                    color: displayColor.withValues(alpha: 0.12),
                    blurRadius: 8, // 增大阴影
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 事件类型图标
                  Icon(
                    icon,
                    size: 18, // 增大图标大小
                    color: shouldHighlight ? displayColor : (isDark ? AppColors.textSecondary : AppColors.textSecondaryLight),
                  ),
                  const SizedBox(width: 12), // 增大间距
                  Expanded( // 添加Expanded确保文本不会溢出
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 16, // 增大字体大小
                              fontWeight: shouldHighlight ? FontWeight.bold : FontWeight.w500,
                              color: textColor,
                              height: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis, // 添加溢出处理
                          ),
                        ),
                        // 星标图标
                        if (isStarred)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.star, // 实心星形
                              size: 18,
                              color: displayColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
