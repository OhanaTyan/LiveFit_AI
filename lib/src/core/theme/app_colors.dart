import 'package:flutter/material.dart';

// 扩展Color类，添加withValues方法来修改透明度
extension ColorExtensions on Color {
  Color withValues({double alpha = 1.0}) {
    return withAlpha((alpha * 255).toInt().clamp(0, 255));
  }
}

class AppColors {
  // 主题1: 现代科技蓝（默认）- 优化版
  /// 设计理念：采用更柔和的蓝色调，营造科技感与专业感，同时提升视觉舒适度
  /// 适用场景：全功能健身应用，适合科技爱好者和追求专业感的用户
  static const ColorScheme modernBlue = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4A6FFF), // 梦幻蓝（主色）
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE8F0FF),
    onPrimaryContainer: Color(0xFF0D47A1),
    secondary: Color(0xFF00E676), // 活力绿（辅助色）
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8F5E8),
    onSecondaryContainer: Color(0xFF1B5E20),
    surface: Color(0xFFFFFFFF), // 纯白卡片
    onSurface: Color(0xFF1A1D2E),
    surfaceContainerHighest: Color(0xFFF9FAFB),
    onSurfaceVariant: Color(0xFF6B7280),
    error: Color(0xFFFF5252),
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    outline: Color(0xFFE8F0FF),
    outlineVariant: Color(0xFFF0F4FF),
    shadow: Color(0x05000000),
    scrim: Colors.black,
    inverseSurface: Color(0xFF1A1D2E),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF90CAF9),
    surfaceTint: Color(0xFF4A6FFF),
  );

  // 主题2: 清新薄荷绿 - 新增方案
  /// 设计理念：采用清新的薄荷绿调，营造自然、健康、活力的氛围，适合健身和健康应用
  /// 适用场景：瑜伽、冥想、健康养生类功能，适合追求自然生活方式的用户
  static const ColorScheme freshMint = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4CAF50), // 清新绿（主色）
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE0F7EF),
    onPrimaryContainer: Color(0xFF1B5E20),
    secondary: Color(0xFF0288D1), // 天蓝（辅助色）
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE3F2FD),
    onSecondaryContainer: Color(0xFF0D47A1),
    surface: Color(0xFFFFFFFF), // 纯白卡片
    onSurface: Color(0xFF1A1D2E),
    surfaceContainerHighest: Color(0xFFF0FFF7),
    onSurfaceVariant: Color(0xFF6B7280),
    error: Color(0xFFFF5252),
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    outline: Color(0xFFE0F7EF),
    outlineVariant: Color(0xFFF0FFF7),
    shadow: Color(0x05000000),
    scrim: Colors.black,
    inverseSurface: Color(0xFF1A1D2E),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFF81C784),
    surfaceTint: Color(0xFF4CAF50),
  );

  // 主题3: 温暖奶油色 - 新增方案
  /// 设计理念：采用温暖的奶油色调，营造舒适、亲切、激励的氛围，适合健身激励和日常使用
  /// 适用场景：健身计划、进度追踪、日常记录，适合需要温暖激励的用户
  static const ColorScheme warmCream = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF6B35), // 活力橙（主色）
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFF0E0),
    onPrimaryContainer: Color(0xFFBF360C),
    secondary: Color(0xFF4CAF50), // 自然绿（辅助色）
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8F5E8),
    onSecondaryContainer: Color(0xFF1B5E20),
    surface: Color(0xFFFFFFFF), // 纯白卡片
    onSurface: Color(0xFF263238),
    surfaceContainerHighest: Color(0xFFFFF7F0),
    onSurfaceVariant: Color(0xFF616161),
    error: Color(0xFFFF5252),
    onError: Colors.white,
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFFB71C1C),
    outline: Color(0xFFFFF0E0),
    outlineVariant: Color(0xFFFFF7F0),
    shadow: Color(0x05000000),
    scrim: Colors.black,
    inverseSurface: Color(0xFF263238),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFFFFB74D),
    surfaceTint: Color(0xFFFF6B35),
  );

  // Social Colors
  static const Color wechat = Color(0xFF07C160);
  static const Color qq = Color(0xFF12B7F5);
  static const Color apple = Colors.white;

  // 通用文本颜色（兼容旧代码）
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3B8);
  static const Color textDisabled = Color(0xFF6E7175);

  static const Color textPrimaryLight = Color(0xFF1A1D2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textDisabledLight = Color(0xFF9CA3AF);

  // 深色主题
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // 主题1: 现代科技蓝（默认）- 优化版
  static const Color backgroundLightModern = Color(0xFFF5F8FF); // 更柔和的梦幻蓝白
  static const Color surfaceLightModern = Color(0xFFFFFFFF);
  static const Color borderLightModern = Color(0xFFE8F0FF);
  static const Color dividerLightModern = Color(0xFFF0F4FF);
  
  // 主题2: 清新薄荷绿 - 新增方案
  static const Color backgroundLightMint = Color(0xFFF0FFF4); // 清新薄荷绿背景
  static const Color surfaceLightMint = Color(0xFFFFFFFF);
  static const Color borderLightMint = Color(0xFFE0F7EF);
  static const Color dividerLightMint = Color(0xFFF0FFF7);
  
  // 主题3: 温暖奶油色 - 新增方案
  static const Color backgroundLightCream = Color(0xFFFFFAF5); // 温暖奶油色背景
  static const Color surfaceLightCream = Color(0xFFFFFFFF);
  static const Color borderLightCream = Color(0xFFFFF0E0);
  static const Color dividerLightCream = Color(0xFFFFF7F0);
  
  // 向后兼容属性
  static const Color primary = Color(0xFF4A6FFF);
  static const Color primaryEnd = Color(0xFF00E676);
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryEnd = Color(0xFFFDD835);
  static const Color backgroundLight = Color(0xFFF5F8FF); // 默认使用优化后的现代科技蓝
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE8F0FF);
  static const Color dividerLight = Color(0xFFF0F4FF);
  static const Color accentLight1 = Color(0xFFE8F5E8);
  static const Color accentLight2 = Color(0xFFE3F2FD);
  static const Color accentLight3 = Color(0xFFFFF3E0);
  static const Color surfaceLightVariant = Color(0xFFF9FAFB);
  static const Color surfaceLightElevated = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB40);
}

// 渐变色工具类 - 更新为支持多主题
class GradientColors {
  // 向后兼容属性
  static const List<Color> primary = [
    Color(0xFF4A6FFF), // 梦幻蓝
    Color(0xFF00E676), // 活力绿
  ];
  
  static const List<Color> secondary = [
    Color(0xFFFF6B6B), // 珊瑚粉
    Color(0xFFFDD835), // 阳光黄
  ];
  
  static const List<Color> accent = [
    Color(0xFF64B5F6), // 天空蓝
    Color(0xFF9575CD), // 薰衣草紫
  ];
  
  static const List<Color> background = [
    Color(0xFFF8FAFF), // 梦幻蓝白
    Color(0xFFF0F4FF), // 淡蓝白
  ];
  
  static const List<Color> card = [
    Color(0xFFFFFFFF), // 纯白
    Color(0xFFF8FAFF), // 梦幻蓝白
  ];
  
  // 现代科技蓝渐变
  static const List<Color> modernBlue = [
    Color(0xFF4A6FFF), // 梦幻蓝
    Color(0xFF00E676), // 活力绿
  ];
  
  // 活力橙渐变
  static const List<Color> energeticOrange = [
    Color(0xFFFF6B35), // 活力橙
    Color(0xFF4CAF50), // 自然绿
  ];
  
  // 宁静绿渐变
  static const List<Color> calmingGreen = [
    Color(0xFF2E7D32), // 深绿
    Color(0xFF0288D1), // 天蓝
  ];
}
