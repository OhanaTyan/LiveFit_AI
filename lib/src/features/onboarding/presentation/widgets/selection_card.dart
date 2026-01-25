import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/gradient_utils.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? imageAsset;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // 使用现代科技蓝主题（可切换为其他主题）
    final colorScheme = AppColors.modernBlue;
    final gradients = GradientColors.modernBlue;
    // 切换主题示例：
    // final colorScheme = AppColors.energeticOrange;
    // final gradients = GradientColors.energeticOrange;
    // final colorScheme = AppColors.calmingGreen;
    // final gradients = GradientColors.calmingGreen;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: double.infinity,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? colorScheme.primaryContainer 
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: isSelected 
                      ? GradientUtils.createLinearGradient(
                          colors: gradients,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected 
                      ? null 
                      : (isDark ? Colors.black26 : colorScheme.primaryContainer.withValues(alpha: 0.6)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected ? Colors.white : colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected 
                    ? colorScheme.primary 
                    : (isDark ? Colors.white : colorScheme.onSurface),
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.4,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}