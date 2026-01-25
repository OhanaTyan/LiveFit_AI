import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';

class ContextStep extends StatelessWidget {
  final OnboardingState state;

  const ContextStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        children: [
          const Text(
            '场景与器械',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI 将根据你的现有条件生成可执行的计划。',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Experience Level
          const Text(
            '健身经验',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildExperienceCard(ExperienceLevel.beginner, '新手', '0-6个月'),
              const SizedBox(width: 12),
              _buildExperienceCard(ExperienceLevel.intermediate, '进阶', '6个月-2年'),
              const SizedBox(width: 12),
              _buildExperienceCard(ExperienceLevel.advanced, '高阶', '2年以上'),
            ],
          ),

          const SizedBox(height: 32),

          // Environments
          const Text(
            '常驻场景 (多选)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildEnvChip(WorkoutEnvironment.dorm, '宿舍', Icons.bed),
              _buildEnvChip(WorkoutEnvironment.office, '办公室', Icons.work),
              _buildEnvChip(WorkoutEnvironment.home, '家', Icons.home),
              _buildEnvChip(WorkoutEnvironment.gym, '健身房', Icons.fitness_center),
              _buildEnvChip(WorkoutEnvironment.outdoor, '户外', Icons.park),
            ],
          ),

          const SizedBox(height: 32),

          // Equipment
          const Text(
            '可用器械 (多选)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildEquipChip(Equipment.none, '无器械', Icons.front_hand),
              _buildEquipChip(Equipment.yogaMat, '瑜伽垫', Icons.layers),
              _buildEquipChip(Equipment.dumbbells, '哑铃', Icons.fitness_center),
              _buildEquipChip(Equipment.resistanceBands, '弹力带', Icons.linear_scale),
            ],
          ),
          const SizedBox(height: 32),

          // Aerobic Activities
          const Text(
            '有氧活动偏好 (多选)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.running, '跑步', Icons.directions_run),
              _buildAerobicChip(AerobicExerciseType.cycling, '骑行', Icons.directions_bike),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceLevel level, String title, String subtitle) {
    final isSelected = state.experienceLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => state.toggleExperienceLevel(level),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary.withValues(alpha: 0.8) : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvChip(WorkoutEnvironment env, String label, IconData icon) {
    final isSelected = state.environments.contains(env);
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: isSelected ? AppColors.backgroundDark : AppColors.textSecondary),
      selected: isSelected,
      onSelected: (_) => state.toggleEnvironment(env),
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.backgroundDark,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildEquipChip(Equipment equip, String label, IconData icon) {
    final isSelected = state.equipment.contains(equip);
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: isSelected ? AppColors.backgroundDark : AppColors.textSecondary),
      selected: isSelected,
      onSelected: (_) => state.toggleEquipment(equip),
      backgroundColor: AppColors.surfaceDark,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: AppColors.backgroundDark,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildAerobicChip(AerobicExerciseType activity, String label, IconData icon) {
    final isSelected = state.aerobicExercises.contains(activity);
    final exerciseTime = isSelected ? state.aerobicExerciseTimes[activity] ?? 30 : 30;
    final isStationaryBike = activity == AerobicExerciseType.stationaryBike;
    
    // For stationary bike, use column layout to avoid overflow
    if (isStationaryBike && isSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterChip(
            label: Text(label),
            avatar: Icon(icon, size: 16, color: isSelected ? AppColors.backgroundDark : AppColors.textSecondary),
            selected: isSelected,
            onSelected: (_) => state.toggleAerobicExercise(activity),
            backgroundColor: AppColors.surfaceDark,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            checkmarkColor: AppColors.backgroundDark,
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('每周时间: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(activity, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  color: AppColors.primary,
                ),
                Text('$exerciseTime 分钟', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(activity, exerciseTime + 15),
                  icon: const Icon(Icons.add_circle, size: 18),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    // For other exercises, use row layout
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilterChip(
          label: Text(label),
          avatar: Icon(icon, size: 16, color: isSelected ? AppColors.backgroundDark : AppColors.textSecondary),
          selected: isSelected,
          onSelected: (_) => state.toggleAerobicExercise(activity),
          backgroundColor: AppColors.surfaceDark,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.backgroundDark : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          checkmarkColor: AppColors.backgroundDark,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Text('每周时间: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(activity, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  color: AppColors.primary,
                ),
                Text('$exerciseTime 分钟', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(activity, exerciseTime + 15),
                  icon: const Icon(Icons.add_circle, size: 18),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
