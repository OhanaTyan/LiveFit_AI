import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';

class GoalStep extends StatelessWidget {
  final OnboardingState state;

  const GoalStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            '你的目标',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '告诉我们你想达到什么效果',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          
          // Goal selection grid
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 20,
            childAspectRatio: 0.95,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildGoalCard(
                FitnessGoal.weightLoss,
                '减脂',
                '燃烧卡路里，降低体脂率',
                Icons.local_fire_department_outlined,
                const [Color(0xFFFF6B6B), Color(0xFFFF8787)],
              ),
              _buildGoalCard(
                FitnessGoal.muscleBuild,
                '增肌',
                '增加肌肉量，提升力量',
                Icons.fitness_center,
                const [Color(0xFF4ECDC4), Color(0xFF45B7AA)],
              ),
              _buildGoalCard(
                FitnessGoal.keepFit,
                '塑形/保持',
                '优化体态，保持健康',
                Icons.accessibility_new_outlined,
                const [Color(0xFF45B7D1), Color(0xFF2196F3)],
              ),
              _buildGoalCard(
                FitnessGoal.endurance,
                '增强体能',
                '提升心肺功能与耐力',
                Icons.directions_run,
                const [Color(0xFF96CEB4), Color(0xFFA8E6CF)],
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          
          // BMI and weight information
          if (state.height != null && state.weight != null) ...[
            const SectionHeader('身体数据'),
            const SizedBox(height: 20),
            
            // BMI display
            _buildInfoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('当前BMI', style: TextStyle(color: AppColors.textSecondaryLight)),
                  Text(
                    state.bmi.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getBMIColor(state.bmi).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getBMICategory(state.bmi),
                      style: TextStyle(
                        color: _getBMIColor(state.bmi),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
          
          // Target weight setting
          if (state.mainGoal == FitnessGoal.weightLoss || state.mainGoal == FitnessGoal.muscleBuild) ...[
            const SectionHeader('目标体重'),
            const SizedBox(height: 20),
            
            // Recommended weight range
            if (state.height != null) ...[
              _buildInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('推荐体重范围', style: TextStyle(color: AppColors.textSecondaryLight)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primaryEnd.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_calculateRecommendedWeightRange(state.height!).first.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(
                              height: 4,
                              child: LinearProgressIndicator(
                                value: 1,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryEnd,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_calculateRecommendedWeightRange(state.height!).last.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '基于健康BMI范围 (18.5-24.0)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Target weight input
            _buildInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('目标体重', style: TextStyle(color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.borderLight,
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withValues(alpha: 0.2),
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                          ),
                          child: Slider(
                            value: _clampTargetWeight(
                              state.targetWeight ?? (state.weight ?? 65),
                              state.height != null ? _calculateRecommendedWeightRange(state.height!).first - 5 : 40,
                              state.height != null ? _calculateRecommendedWeightRange(state.height!).last + 5 : 100,
                            ),
                            min: state.height != null ? _calculateRecommendedWeightRange(state.height!).first - 5 : 40,
                            max: state.height != null ? _calculateRecommendedWeightRange(state.height!).last + 5 : 100,
                            divisions: 120,
                            onChanged: (value) => state.setTargetWeight(value),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                          width: 130,
                          height: 48,
                          child: TextField(
                            controller: TextEditingController(
                              text: (state.targetWeight ?? (state.weight ?? 65)).toStringAsFixed(1)
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              suffix: const Text(' kg', style: TextStyle(color: Colors.white)),
                              filled: true,
                              fillColor: AppColors.primary,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red, width: 2),
                              ),
                            ),
                            onSubmitted: (value) {
                              final double? weight = double.tryParse(value);
                              if (weight != null) {
                                final double min = state.height != null ? (_calculateRecommendedWeightRange(state.height!).first - 5) : 40;
                                final double max = state.height != null ? (_calculateRecommendedWeightRange(state.height!).last + 5) : 100;
                                
                                // Check if weight is outside the range and show a snackbar
                                if (weight < min || weight > max) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '体重范围应在 ${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)} kg 之间',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppColors.primary,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                                
                                state.setTargetWeight(_clampTargetWeight(weight, min, max));
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 48),
          
          // Calorie information
          if (state.height != null && state.weight != null && state.birthday != null && state.gender != null && state.mainGoal != null) ...[
            const SectionHeader('热量需求'),
            const SizedBox(height: 20),
            
            // Calorie details
            _buildInfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalorieRow('基础代谢率 (BMR)', '${state.bmr} 卡路里/天'),
                  const SizedBox(height: 16),
                  _buildCalorieRow('总消耗热量 (TDEE)', '${state.tdee} 卡路里/天'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primaryEnd.withValues(alpha: 0.1),
                          ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '推荐热量摄入',
                          style: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${state.recommendedCalories} 卡路里/天',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLightVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getCalorieRecommendationText(state.mainGoal!),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildGoalCard(FitnessGoal goal, String title, String subtitle, IconData icon, List<Color> gradientColors) {
    bool isSelected = state.mainGoal == goal;
    
    return GestureDetector(
      onTap: () => state.setMainGoal(goal),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: gradientColors)
              : null,
          color: isSelected ? null : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.borderLight,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppColors.surfaceLightVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : AppColors.textPrimaryLight,
              ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : AppColors.textSecondaryLight,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCalorieRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
      ],
    );
  }

  // Helper methods
  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return '偏瘦';
    if (bmi < 24) return '正常';
    if (bmi < 28) return '超重';
    return '肥胖';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFFFFD93D);
    if (bmi < 24) return const Color(0xFF6BCB77);
    if (bmi < 28) return const Color(0xFFFF6B6B);
    return const Color(0xFFFF6B6B);
  }

  Range<double> _calculateRecommendedWeightRange(double height) {
    // Calculate based on BMI 18.5-24.0
    double heightInMeters = height / 100;
    double minWeight = 18.5 * heightInMeters * heightInMeters;
    double maxWeight = 24.0 * heightInMeters * heightInMeters;
    return Range(minWeight, maxWeight);
  }
  
  String _getCalorieRecommendationText(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.weightLoss:
        return '建议每天减少500卡路里，每周可健康减重0.5-1公斤。配合有氧运动和合理饮食，达到理想体重。';
      case FitnessGoal.muscleBuild:
        return '建议每天增加300卡路里，配合力量训练促进肌肉增长。确保摄入足够的蛋白质和营养。';
      case FitnessGoal.keepFit:
        return '保持当前热量摄入，维持健康体重。定期进行综合训练，保持身体活力。';
      case FitnessGoal.endurance:
        return '根据训练强度调整热量摄入，确保足够的能量供应。增加碳水化合物摄入，提高耐力表现。';
    }
  }

  double _clampTargetWeight(double currentValue, double min, double max) {
    if (currentValue < min) {
      return min;
    } else if (currentValue > max) {
      return max;
    }
    return currentValue;
  }
}

// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  
  const SectionHeader(this.title, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.25,
      ),
    );
  }
}

// Helper class for range
class Range<T> {
  final T first;
  final T last;
  
  const Range(this.first, this.last);
  
  T get min => first;
  T get max => last;
}
