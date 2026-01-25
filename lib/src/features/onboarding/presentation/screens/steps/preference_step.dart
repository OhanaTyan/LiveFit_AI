import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';

class PreferenceStep extends StatelessWidget {
  final OnboardingState state;

  const PreferenceStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '运动偏好',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '选择你喜欢的运动类型，AI 将为你推荐更符合你喜好的计划。',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 32),

          // Weekly Exercise Time
          const Text(
            '每周运动时间',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTimeChip(WeeklyExerciseTime.lessThan30Minutes, '少于30分钟'),
              _buildTimeChip(WeeklyExerciseTime.thirtyMinutes, '30分钟'),
              _buildTimeChip(WeeklyExerciseTime.oneHour, '1小时'),
              _buildTimeChip(WeeklyExerciseTime.oneAndHalfHours, '1.5小时'),
              _buildTimeChip(WeeklyExerciseTime.twoHours, '2小时'),
              _buildTimeChip(WeeklyExerciseTime.moreThanTwoHours, '超过2小时'),
            ],
          ),

          const SizedBox(height: 32),

          // Preferred Workout Time
          const Text(
            '偏好运动时段',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPreferredTimeChip(PreferredWorkoutTime.earlyMorning, '凌晨'),
              _buildPreferredTimeChip(PreferredWorkoutTime.morning, '早晨'),
              _buildPreferredTimeChip(PreferredWorkoutTime.noon, '中午'),
              _buildPreferredTimeChip(PreferredWorkoutTime.evening, '傍晚'),
              _buildPreferredTimeChip(PreferredWorkoutTime.midnight, '午夜'),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTimeChip(WeeklyExerciseTime time, String label) {
    final isSelected = state.weeklyExerciseTime == time;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => state.setWeeklyExerciseTime(time),
      backgroundColor: AppColors.surfaceLight,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.surfaceLight : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.surfaceLight,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderLight, width: 1),
      ),
    );
  }

  Widget _buildPreferredTimeChip(PreferredWorkoutTime time, String label) {
    final isSelected = state.preferredWorkoutTime == time;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => state.setPreferredWorkoutTime(time),
      backgroundColor: AppColors.surfaceLight,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.surfaceLight : AppColors.textPrimaryLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.surfaceLight,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderLight, width: 1),
      ),
    );
  }
}
