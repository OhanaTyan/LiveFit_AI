import 'package:flutter/material.dart';
import 'package:life_fit/src/core/localization/app_localizations.dart';
import 'package:life_fit/src/core/theme/app_colors.dart';

class EmptyScheduleView extends StatelessWidget {
  const EmptyScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: isDark ? AppColors.textDisabled : AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noScheduleToday,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.clickToAddTask,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDisabled : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
