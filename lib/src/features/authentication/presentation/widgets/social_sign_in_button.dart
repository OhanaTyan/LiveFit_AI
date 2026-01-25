import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final double? width;
  final bool isOutlined;

  const SocialSignInButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.width,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isOutlined ? Colors.transparent : color;
    final effectiveTextColor = textColor ?? (isOutlined ? color : Colors.white);
    final effectiveIconColor = iconColor ?? effectiveTextColor;
    
    return Container(
      width: width,
      height: 56, // Fixed comfortable height
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16), // Standard Rounded Rectangle
        border: isOutlined 
            ? Border.all(color: borderColor ?? color, width: 1.5)
            : null,
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                // 1. Icon aligned to the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icon, color: effectiveIconColor, size: 24),
                ),
                // 2. Text strictly centered
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
