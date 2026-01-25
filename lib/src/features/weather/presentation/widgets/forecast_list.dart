import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/utils/weather_icons.dart';
import '../../../weather/utils/temperature_converter.dart';

class ForecastList extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const ForecastList({
    super.key,
    required this.weatherProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final forecast = weatherProvider.forecast;

    if (forecast == null || forecast.forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? GradientColors.backgroundDark : GradientColors.card,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5天预报',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '最高/最低',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 预报列表
          Column(
            children: forecast.forecasts.map((item) {
              return _buildForecastItem(isDark, item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastItem(bool isDark, dynamic forecastItem) {
    final temperatureUnit = weatherProvider.temperatureUnit;
    final maxTemp = TemperatureConverter.formatTemperature(
      forecastItem.maxTemperature,
      temperatureUnit,
    );
    final minTemp = TemperatureConverter.formatTemperature(
      forecastItem.minTemperature,
      temperatureUnit,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 日期
          Text(
            forecastItem.date,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
          
          // 天气图标
          Icon(
            WeatherIcons.getIcon(forecastItem.iconCode),
            size: 24,
            color: WeatherIcons.getIconColor(forecastItem.iconCode),
          ),
          
          // 天气状况
          Text(
            forecastItem.weatherCondition,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
          
          // 温度范围
          Row(
            children: [
              Text(
                maxTemp,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                minTemp,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 渐变颜色定义
class GradientColors {
  static const List<Color> card = [
    Color(0xFFFFFFFF),
    Color(0xFFF8FAFF),
  ];
  
  static const List<Color> backgroundDark = [
    Color(0xFF1E1E1E),
    Color(0xFF2D2D2D),
  ];
}
