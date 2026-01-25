import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyAgreementRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onProtocolTap;
  final VoidCallback onPrivacyTap;

  const PrivacyAgreementRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onProtocolTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            side: const BorderSide(color: AppColors.textDisabled, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '我已阅读并同意 ',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = onProtocolTap,
                ),
                const TextSpan(text: ' 和 '),
                TextSpan(
                  text: '《隐私政策》',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                ),
                const TextSpan(text: '，未注册手机号将自动创建账号。'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
