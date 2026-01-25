import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';

// Icon mapping for aerobic exercises
const Map<AerobicExerciseType, IconData> aerobicExerciseIcons = {
  // Running
  AerobicExerciseType.running: Icons.directions_run,
  AerobicExerciseType.jogging: Icons.run_circle,
  AerobicExerciseType.walking: Icons.directions_walk,
  
  // Cycling
  AerobicExerciseType.cycling: Icons.directions_bike,
  AerobicExerciseType.stationaryBike: Icons.pedal_bike,
  
  // Swimming
  AerobicExerciseType.swimming: Icons.pool,
  
  //球类
  AerobicExerciseType.basketball: Icons.sports_basketball,
  AerobicExerciseType.football: Icons.sports_soccer,
  AerobicExerciseType.tennis: Icons.sports_tennis,
  AerobicExerciseType.badminton: Icons.sports_tennis,
  AerobicExerciseType.volleyball: Icons.sports_volleyball,
  
  // 其他
  AerobicExerciseType.aerobics: Icons.fitness_center,
  AerobicExerciseType.dancing: Icons.directions_walk,
  AerobicExerciseType.jumpingRope: Icons.fitness_center,
  AerobicExerciseType.hiking: Icons.hiking,
  
  // 水上运动
  AerobicExerciseType.waterAerobics: Icons.pool,
  
  // 冬季运动
  AerobicExerciseType.skiing: Icons.downhill_skiing,
  AerobicExerciseType.skating: Icons.skateboarding,
};

class ContextStep extends StatelessWidget {
  final OnboardingState state;

  const ContextStep({super.key, required this.state});

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
            '场景与器械',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI 将根据你的现有条件生成可执行的计划。',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 32),

          // Experience Level
          const Text(
            '健身经验',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
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
              _buildEquipChip(Equipment.fullGym, '综合健身房', Icons.sports_gymnastics),
            ],
          ),
          const SizedBox(height: 32),

          // Aerobic Exercise
          const Text(
            '日常活动习惯 (多选)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
          ),
          const SizedBox(height: 16),

          // Running
          const Text(
            '跑步类',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.running, '跑步', aerobicExerciseIcons[AerobicExerciseType.running]!),
              _buildAerobicChip(AerobicExerciseType.jogging, '慢跑', aerobicExerciseIcons[AerobicExerciseType.jogging]!),
              _buildAerobicChip(AerobicExerciseType.walking, '步行', aerobicExerciseIcons[AerobicExerciseType.walking]!),
            ],
          ),

          const SizedBox(height: 16),

          // Cycling
          const Text(
            '骑行类',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.cycling, '骑行', aerobicExerciseIcons[AerobicExerciseType.cycling]!),
              _buildAerobicChip(AerobicExerciseType.stationaryBike, '固定自行车', aerobicExerciseIcons[AerobicExerciseType.stationaryBike]!),
            ],
          ),

          const SizedBox(height: 16),

          // Swimming
          const Text(
            '游泳类',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.swimming, '游泳', aerobicExerciseIcons[AerobicExerciseType.swimming]!),
              _buildAerobicChip(AerobicExerciseType.waterAerobics, '水中有氧', aerobicExerciseIcons[AerobicExerciseType.waterAerobics]!),
            ],
          ),

          const SizedBox(height: 16),

          //球类
          const Text(
            '球类',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.basketball, '篮球', aerobicExerciseIcons[AerobicExerciseType.basketball]!),
              _buildAerobicChip(AerobicExerciseType.football, '足球', aerobicExerciseIcons[AerobicExerciseType.football]!),
              _buildAerobicChip(AerobicExerciseType.tennis, '网球', aerobicExerciseIcons[AerobicExerciseType.tennis]!),
              _buildAerobicChip(AerobicExerciseType.badminton, '羽毛球', aerobicExerciseIcons[AerobicExerciseType.badminton]!),
              _buildAerobicChip(AerobicExerciseType.volleyball, '排球', aerobicExerciseIcons[AerobicExerciseType.volleyball]!),
            ],
          ),

          const SizedBox(height: 16),

          // 其他
          const Text(
            '其他',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAerobicChip(AerobicExerciseType.aerobics, '有氧操', aerobicExerciseIcons[AerobicExerciseType.aerobics]!),
              _buildAerobicChip(AerobicExerciseType.dancing, '跳舞', aerobicExerciseIcons[AerobicExerciseType.dancing]!),
              _buildAerobicChip(AerobicExerciseType.jumpingRope, '跳绳', aerobicExerciseIcons[AerobicExerciseType.jumpingRope]!),
              _buildAerobicChip(AerobicExerciseType.hiking, '徒步', aerobicExerciseIcons[AerobicExerciseType.hiking]!),
              _buildAerobicChip(AerobicExerciseType.skiing, '滑雪', aerobicExerciseIcons[AerobicExerciseType.skiing]!),
              _buildAerobicChip(AerobicExerciseType.skating, '滑冰', aerobicExerciseIcons[AerobicExerciseType.skating]!),
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
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimaryLight.withValues(alpha: 0.8) : AppColors.textSecondaryLight,
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
      avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
      selected: isSelected,
      onSelected: (_) => state.toggleEnvironment(env),
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

  Widget _buildEquipChip(Equipment equip, String label, IconData icon) {
    final isSelected = state.equipment.contains(equip);
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
      selected: isSelected,
      onSelected: (_) => state.toggleEquipment(equip),
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

  Widget _buildAerobicChip(AerobicExerciseType exercise, String label, IconData icon) {
    final isSelected = state.aerobicExercises.contains(exercise);
    final exerciseTime = isSelected ? state.aerobicExerciseTimes[exercise] ?? 30 : 30;
    final isStationaryBike = exercise == AerobicExerciseType.stationaryBike;
    
    // For stationary bike, use column layout to avoid overflow
    if (isStationaryBike && isSelected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterChip(
            label: Text(label),
            avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
            selected: isSelected,
            onSelected: (_) => state.toggleAerobicExercise(exercise),
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('每周时间: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(exercise, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  color: AppColors.primary,
                ),
                Text('$exerciseTime 分钟', style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryLight)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(exercise, exerciseTime + 15),
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
          avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
          selected: isSelected,
          onSelected: (_) => state.toggleAerobicExercise(exercise),
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
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Text('每周时间: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(exercise, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  color: AppColors.primary,
                ),
                Text('$exerciseTime 分钟', style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryLight)),
                IconButton(
                  onPressed: () => state.setAerobicExerciseTime(exercise, exerciseTime + 15),
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