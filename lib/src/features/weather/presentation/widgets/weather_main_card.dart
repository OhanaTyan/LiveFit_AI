import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/utils/weather_icons.dart';
import '../../../weather/utils/temperature_converter.dart';

class WeatherMainCard extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final VoidCallback onRefresh;
  final VoidCallback onSettingsTap;

  const WeatherMainCard({
    super.key,
    required this.weatherProvider,
    required this.onRefresh,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weather = weatherProvider.currentWeather;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;

    if (isLoading) {
      return _buildLoadingCard(isDark);
    }

    if (weather != null) {
      return _buildWeatherCard(isDark, weather, error);
    }

    if (error != null) {
      return _buildErrorCard(isDark, error, onRefresh);
    }

    return _buildEmptyCard(isDark, onRefresh);
  }

  Widget _buildLoadingCard(bool isDark) {
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
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorCard(bool isDark, String error, VoidCallback onRefresh) {
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
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.textPrimaryLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(bool isDark, VoidCallback onRefresh) {
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
          const Icon(Icons.cloud_off, size: 48, color: AppColors.secondary),
          const SizedBox(height: 16),
          Text(
            '未获取到天气数据',
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.textPrimaryLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击刷新按钮获取天气信息',
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('刷新'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(bool isDark, dynamic weather, String? error) {
    final temperatureUnit = weatherProvider.temperatureUnit;
    final formattedTemp = TemperatureConverter.formatTemperature(
      weather.temperature,
      temperatureUnit,
    );

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
          // 头部：位置标题、城市名和操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 位置标题和城市名
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '当前位置',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.city,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.textPrimaryLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // 操作按钮
              Row(
                children: [
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.textSecondaryLight,
                  ),
                  IconButton(
                    onPressed: onSettingsTap,
                    icon: const Icon(Icons.settings_outlined),
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.textSecondaryLight,
                  ),
                ],
              ),
            ],
          ),

          // 错误提示（如果有）
          if (error != null) _buildErrorBanner(isDark, error),

          // 主要天气信息
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedTemp,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.textPrimaryLight,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather.weatherCondition,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryLight,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Icon(
                WeatherIcons.getIcon(weather.iconCode),
                size: 64,
                color: WeatherIcons.getIconColor(weather.iconCode),
              ),
            ],
          ),

          // 详细信息
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetailItem(
                isDark,
                Icons.water_drop_outlined,
                '湿度',
                '${weather.humidity}%',
              ),
              _buildWeatherDetailItem(
                isDark,
                Icons.air,
                '风力',
                '${weather.windSpeed} m/s',
              ),
              _buildWeatherDetailItem(
                isDark,
                Icons.compass_calibration_outlined,
                '气压',
                '${weather.pressure} hPa',
              ),
            ],
          ),

          // 更新时间
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '更新于: ${weather.lastUpdated.hour}:${weather.lastUpdated.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: isDark
                    ? AppColors.textDisabled
                    : AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(bool isDark, String error) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error, width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '更新失败: $error',
              style: TextStyle(
                color: isDark ? AppColors.error : AppColors.error,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailItem(
    bool isDark,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: isDark
              ? AppColors.textSecondary
              : AppColors.textSecondaryLight,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.textSecondaryLight,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// 渐变颜色定义
class GradientColors {
  static const List<Color> card = [Color(0xFFFFFFFF), Color(0xFFF8FAFF)];

  static const List<Color> backgroundDark = [
    Color(0xFF1E1E1E),
    Color(0xFF2D2D2D),
  ];
}
