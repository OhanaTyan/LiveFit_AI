import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/utils/weather_icons.dart';
import '../../../weather/utils/temperature_converter.dart';
import 'weather_expanded_card.dart';

// 渐变颜色定义 - 热重载测试
class GradientColors {
  static const List<Color> card = [Color(0xFFFFFFFF), Color(0xFFF8FAFF)];

  static const List<Color> backgroundDark = [
    Color(0xFF1E1E1E),
    Color(0xFF2D2D2D),
  ];
}

class WeatherExpandableCard extends StatefulWidget {
  final WeatherProvider weatherProvider;
  final VoidCallback onRefresh;
  final VoidCallback onLocationChange;
  final VoidCallback onSettingsTap;

  const WeatherExpandableCard({
    super.key,
    required this.weatherProvider,
    required this.onRefresh,
    required this.onLocationChange,
    required this.onSettingsTap,
  });

  @override
  State<WeatherExpandableCard> createState() => _WeatherExpandableCardState();
}

class _WeatherExpandableCardState extends State<WeatherExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weather = widget.weatherProvider.currentWeather;
    final isLoading = widget.weatherProvider.isLoading;
    final error = widget.weatherProvider.error;

    if (isLoading) {
      return _buildLoadingCard(isDark);
    }

    if (weather != null) {
      return _isExpanded
          ? WeatherExpandedCard(
              weatherProvider: widget.weatherProvider,
              onRefresh: widget.onRefresh,
              onCollapse: () {
                setState(() {
                  _isExpanded = false;
                });
              },
            )
          : _buildWeatherCard(isDark, weather, error);
    }

    if (error != null) {
      return _buildErrorCard(isDark, error);
    }

    return _buildEmptyCard(isDark);
  }

  Widget _buildLoadingCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.backgroundDark, AppColors.surfaceDark]
              : GradientColors.card,
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

  Widget _buildErrorCard(bool isDark, String error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.backgroundDark, AppColors.surfaceDark]
              : GradientColors.card,
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
            onPressed: widget.onRefresh,
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

  Widget _buildErrorBanner(bool isDark, String error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              style: TextStyle(color: AppColors.error, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.backgroundDark, AppColors.surfaceDark]
              : GradientColors.card,
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
            onPressed: widget.onRefresh,
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
    final temperatureUnit = widget.weatherProvider.temperatureUnit;
    final formattedTemp = TemperatureConverter.formatTemperature(
      weather.temperature,
      temperatureUnit,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.backgroundDark, AppColors.surfaceDark]
                : [AppColors.surfaceLight, AppColors.surfaceLightVariant],
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
            // 头部：位置、刷新和设置按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 位置信息
                  GestureDetector(
                    onTap: widget.onLocationChange,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '当前位置',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.textSecondaryLight,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              weather.city,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.textPrimaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 18,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondaryLight,
                        ),
                      ],
                    ),
                  ),
                  // 操作按钮
                  Row(
                    children: [
                      IconButton(
                        onPressed: widget.onRefresh,
                        icon: const Icon(Icons.refresh_outlined),
                        iconSize: 20,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textSecondaryLight,
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        onPressed: widget.onSettingsTap,
                        icon: const Icon(Icons.settings_outlined),
                        iconSize: 20,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.textSecondaryLight,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 错误提示（如果有）
            if (error != null) _buildErrorBanner(isDark, error),

            // 核心天气数据
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
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
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                    size: 80,
                    color: WeatherIcons.getIconColor(weather.iconCode),
                  ),
                ],
              ),
            ),

            // 展开按钮
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 24,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
