import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';
import '../../widgets/selection_card.dart';

class DietStep extends StatelessWidget {
  final OnboardingState state;

  const DietStep({super.key, required this.state});

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
            '饮食偏好',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '选择您的饮食偏好，我们将根据您的选择提供个性化的营养建议和饮食计划。',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          _buildOption(
            DietPreference.standard,
            '常规均衡',
            '无特殊忌口，均衡摄入各类营养素，适合大多数健康人群'
          ),
          const SizedBox(height: 16),
          _buildOption(
            DietPreference.lowCarb,
            '低碳水',
            '减少米饭、面条、糖分等碳水化合物摄入，有助于控制血糖和体重'
          ),
          const SizedBox(height: 16),
          _buildOption(
            DietPreference.highProtein,
            '高蛋白',
            '侧重摄入肉类、蛋类、奶类、豆制品等高蛋白食物，适合增肌和减脂人群'
          ),
          const SizedBox(height: 16),
          _buildOption(
            DietPreference.vegetarian,
            '素食',
            '不食用肉类，通过植物性食物获取营养，包括蔬菜、水果、全谷物、豆类等'
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOption(DietPreference diet, String title, String subtitle) {
    return SelectionCard(
      title: title,
      subtitle: subtitle,
      isSelected: state.dietPreference == diet,
      onTap: () => state.setDietPreference(diet),
    );
  }
}
