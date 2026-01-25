import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/onboarding_state.dart';

class SummaryStep extends StatelessWidget {
  final OnboardingState state;

  const SummaryStep({super.key, required this.state});
  
  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

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
            '初始化完成！',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '基于你的身体数据与目标，我们为你生成的健康档案。',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Main Stats Card - Artistic Redesign
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                  const Color(0xFF00E676).withValues(alpha: 0.1),
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '每日推荐热量',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    '${state.recommendedCalories}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'kcal',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('基础代谢', '${state.bmr}'),
                    Container(
                      width: 1,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, AppColors.textSecondaryLight.withValues(alpha: 0.3), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    _buildStatItem('每日消耗', '${state.tdee}'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Battery Visual (Mock) - Artistic Redesign
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                  const Color(0xFF00E676).withValues(alpha: 0.08),
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6FFF).withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Artistic Battery Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A6FFF).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '初始身体电池',
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        '100% (满电出发)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            '提示: 这是一个基于公式的估算值。LifeFit 会随着你的实际记录和体重变化，动态调整这个目标。',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Aerobic Exercise Calories
          const Text(
            '日常活动消耗',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Individual aerobic exercise calories
          if (state.aerobicExercises.isNotEmpty) ...[
            Column(
              children: state.aerobicExercises.map((exerciseType) {
                final time = state.aerobicExerciseTimes[exerciseType] ?? 0;
                final calories = state.calculateCaloriesForExercise(exerciseType);
                final l10n = AppLocalizations.of(context)!;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.getAerobicExerciseTypeName(_capitalize(exerciseType.name)),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.aerobicWeeklyTime} $time ${l10n.minutes}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          '$calories kcal',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Total aerobic exercise calories
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                    const Color(0xFF00E676).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '每周总消耗',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      '${state.weeklyAerobicCaloriesBurned} kcal',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Custom Calorie Data
          const Text(
            '热量数据详情',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                  const Color(0xFF00E676).withValues(alpha: 0.1),
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.6, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6FFF).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Basal Metabolism
                _buildCustomStatItem('基础代谢', state.customBasalMetabolism.toStringAsFixed(0)),
                const SizedBox(height: 16),
                
                // No Exercise Total Consumption
                _buildCustomStatItem('无运动总消耗', state.customNoExerciseTotalConsumption.toStringAsFixed(0)),
                const SizedBox(height: 16),
                
                // Strength Training Consumption
                _buildCustomStatItem('力训消耗', state.customStrengthTrainingConsumption.toStringAsFixed(0)),
                const SizedBox(height: 16),
                
                // Aerobic Consumption
                _buildCustomStatItem('有氧消耗', state.customAerobicConsumption.toStringAsFixed(0)),
                const SizedBox(height: 24),
                
                // Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppColors.textSecondaryLight.withValues(alpha: 0.3), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Strength Training Day Balance
                _buildCustomStatItem('力训日平衡热量', state.customStrengthTrainingDayBalance.toStringAsFixed(0)),
                const SizedBox(height: 16),
                
                // Rest Day Balance
                _buildCustomStatItem('休息日平衡热量', state.customRestDayBalance.toStringAsFixed(0)),
                const SizedBox(height: 24),
                
                // Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppColors.textSecondaryLight.withValues(alpha: 0.3), Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Strength Training Day Should Eat
                _buildCustomStatItem('力训日应吃热量', state.customStrengthTrainingDayShouldEat.toStringAsFixed(0)),
                const SizedBox(height: 16),
                
                // Rest Day Should Eat
                _buildCustomStatItem('休息日应吃热量', state.customRestDayShouldEat.toStringAsFixed(0)),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildCustomStatItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [Color(0xFF4A6FFF), Color(0xFF00E676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
