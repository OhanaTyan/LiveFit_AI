import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';
import '../../widgets/selection_card.dart';

class PhysiqueStep extends StatelessWidget {
  final OnboardingState state;

  const PhysiqueStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        children: [
          const Text(
            '身体数据',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '这些数据将帮助 AI 构建你的“数字孪生”。',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Height
          _buildSlider(
            context,
            title: '身高',
            value: state.height,
            defaultValue: 170.0,
            min: 140,
            max: 220,
            unit: 'cm',
            onChanged: (val) => state.setHeight(val),
          ),
          const SizedBox(height: 24),

          // Weight
          _buildSlider(
            context,
            title: '体重',
            value: state.weight,
            defaultValue: 65.0,
            min: 40,
            max: 150,
            unit: 'kg',
            onChanged: (val) => state.setWeight(val),
          ),
          const SizedBox(height: 24),

          // BMI Indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('BMI 指数', style: TextStyle(color: AppColors.textSecondary)),
                Text(
                  state.bmi.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Somatotype
          const Text(
            '体胚类型 (Somatotype)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '如果不确定，请选择最接近你自然状态的一项。',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          
          _buildSomatotypeOption(
            Somatotype.ectomorph,
            '外胚型 (Ectomorph)',
            '偏瘦，四肢修长，代谢快，不易增重',
          ),
          const SizedBox(height: 12),
          _buildSomatotypeOption(
            Somatotype.mesomorph,
            '中胚型 (Mesomorph)',
            '天生运动型，骨骼宽大，易增肌易减脂',
          ),
          const SizedBox(height: 12),
          _buildSomatotypeOption(
            Somatotype.endomorph,
            '内胚型 (Endomorph)',
            '骨架大，身形圆润，代谢较慢，易发胖',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context, {
    required String title,
    required double? value,
    required double defaultValue,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
            Text(
              value != null ? '${value.round()} $unit' : '未设置',
              style: TextStyle(
                color: value != null ? AppColors.primary : AppColors.textSecondary,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: value != null ? AppColors.primary : AppColors.surfaceDark,
            inactiveTrackColor: AppColors.surfaceDark,
            thumbColor: value != null ? AppColors.primary : AppColors.textSecondary,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value ?? min,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSomatotypeOption(Somatotype type, String title, String subtitle) {
    return SelectionCard(
      title: title,
      subtitle: subtitle,
      isSelected: state.somatotype == type,
      onTap: () => state.setSomatotype(type),
    );
  }
}
