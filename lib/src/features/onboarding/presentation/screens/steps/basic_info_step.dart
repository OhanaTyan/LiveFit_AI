import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/onboarding_state.dart';
import '../../widgets/selection_card.dart';

class BasicInfoStep extends StatefulWidget {
  final OnboardingState state;

  const BasicInfoStep({super.key, required this.state});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
      text: widget.state.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.state.weight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.state.birthday ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.surfaceLight,
              surface: AppColors.surfaceLight,
              onSurface: AppColors.textPrimaryLight,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: AppColors.surfaceLight),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != widget.state.birthday) {
      widget.state.setBirthday(picked);
    }
  }

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
            '基本信息',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '用于计算基础代谢 (BMR) 和推荐合适的运动强度。',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 40),
          
          // Gender
          const Text(
            '性别',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 300,
              child: Row(
                children: [
                  Expanded(
                    child: SelectionCard(
                      title: '男',
                      icon: Icons.male,
                      isSelected: widget.state.gender == Gender.male,
                      onTap: () => widget.state.setGender(Gender.male),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SelectionCard(
                      title: '女',
                      icon: Icons.female,
                      isSelected: widget.state.gender == Gender.female,
                      onTap: () => widget.state.setGender(Gender.female),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Birthday
          const Text(
            '出生日期',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.textSecondaryLight.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.cake_outlined, color: AppColors.textPrimaryLight),
                  const SizedBox(width: 16),
                  Text(
                    widget.state.birthday != null 
                        ? '${widget.state.birthday!.year}年 ${widget.state.birthday!.month}月 ${widget.state.birthday!.day}日'
                        : '请选择出生日期',
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.state.birthday != null ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimaryLight),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          Text(
            '当前年龄: ${widget.state.age} 岁',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          
          // Height
          const Text(
            '身高 (cm)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textSecondaryLight.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: const InputDecoration(
                hintText: '请输入身高',
                prefixIcon: Icon(Icons.height, color: AppColors.textPrimaryLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              ),
              onChanged: (value) {
                try {
                  // 保存光标位置
                  final selection = _heightController.selection;
                  
                  if (value.isNotEmpty) {
                    final height = double.parse(value);
                    // 身高范围验证：50cm - 250cm
                    if (height >= 50 && height <= 250) {
                      widget.state.setHeight(height);
                    }
                  } else {
                    // 清空输入时，不调用setHeight，保持当前状态
                  }
                  
                  // 恢复光标位置
                  _heightController.selection = selection;
                } catch (e) {
                  // 忽略无效输入
                }
              },
              controller: _heightController,
              style: TextStyle(
                fontSize: 18,
                color: widget.state.height != null ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Weight
          const Text(
            '体重 (kg)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.textSecondaryLight.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: const InputDecoration(
                hintText: '请输入体重',
                prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppColors.textPrimaryLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              ),
              onChanged: (value) {
                try {
                  // 保存光标位置
                  final selection = _weightController.selection;
                  
                  if (value.isNotEmpty) {
                    final weight = double.parse(value);
                    // 体重范围验证：20kg - 300kg
                    if (weight >= 20 && weight <= 300) {
                      widget.state.setWeight(weight);
                    }
                  } else {
                    // 清空输入时，不调用setWeight，保持当前状态
                  }
                  
                  // 恢复光标位置
                  _weightController.selection = selection;
                } catch (e) {
                  // 忽略无效输入
                }
              },
              controller: _weightController,
              style: TextStyle(
                fontSize: 18,
                color: widget.state.weight != null ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
