import 'package:flutter/material.dart';

// 渐变工具类
class GradientUtils {
  // 创建线性渐变
  static LinearGradient createLinearGradient({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
    );
  }
  
  // 创建径向渐变
  static RadialGradient createRadialGradient({
    required List<Color> colors,
    Alignment center = Alignment.center,
    double radius = 0.5,
  }) {
    return RadialGradient(
      colors: colors,
      center: center,
      radius: radius,
    );
  }
  
  // 创建文字渐变
  static Shader createTextGradient({
    required List<Color> colors,
    double width = 200,
    double height = 50,
  }) {
    return LinearGradient(
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, width, height));
  }
  
  // 创建渐变按钮样式
  static ButtonStyle createGradientButtonStyle({
    required List<Color> gradientColors,
    TextStyle? textStyle,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(textStyle),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  // 创建渐变装饰
  static BoxDecoration createGradientDecoration({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    BorderRadiusGeometry? borderRadius,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: borderRadius,
    );
  }
}
