import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';
import '../../widgets/selection_card.dart';

class IdentityStep extends StatelessWidget {
  final OnboardingState state;

  const IdentityStep({super.key, required this.state});

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
            '首先，我们要如何称呼你？',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '选择最符合你当前状态的身份，帮助 AI 更懂你的日程。',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            children: [
                _buildOption(
                  UserPersona.busyProfessional,
                  '忙碌打工人',
                  '会议多，久坐，需要碎片化运动',
                  Icons.work_outline,
                ),
                _buildOption(
                  UserPersona.student,
                  '在校大学生',
                  '宿舍空间有限，利用课间与操场',
                  Icons.school_outlined,
                ),
                _buildOption(
                  UserPersona.adaptiveAthlete,
                  '进阶健身党',
                  '追求训练容量，灵活替代动作',
                  Icons.fitness_center_outlined,
                ),
                _buildOption(
                  UserPersona.beginner,
                  '亚健康/初学者',
                  '体能较弱，需要游戏化激励',
                  Icons.battery_charging_full_outlined,
                ),
                _buildOption(
                  UserPersona.everydayPerson,
                  '普通生活家',
                  '关注长期健康，养生与柔韧性',
                  Icons.self_improvement_outlined,
                ),
                _buildOption(
                  UserPersona.senior,
                  '中老年朋友',
                  '注重关节健康，低强度有氧运动',
                  Icons.accessibility_new_outlined,
                ),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(UserPersona persona, String title, String subtitle, IconData icon) {
    return SelectionCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      isSelected: state.persona == persona,
      onTap: () => state.setPersona(persona),
    );
  }
}
