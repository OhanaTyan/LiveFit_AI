import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

class WeatherCompactCard extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final VoidCallback onRefresh;
  final VoidCallback onExpand;

  const WeatherCompactCard({
    super.key,
    required this.weatherProvider,
    required this.onRefresh,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weather = weatherProvider.currentWeather;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;
    
    Widget cardContent;
    
    if (isLoading) {
      cardContent = _buildLoadingCard(isDark);
    } else if (error != null) {
      cardContent = _buildErrorCard(isDark, error);
    } else if (weather == null) {
      cardContent = _buildEmptyCard(isDark);
    } else {
      cardContent = _buildWeatherCard(isDark, weather);
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 天气卡片
        cardContent,
        
        // 展开指示器 - 完全符合用户需求：简单的下拉箭头，位于卡片下方中心
        // 只有在有数据时才显示展开指示器
        if (weather != null) 
          GestureDetector(
            onTap: onExpand,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildLoadingCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
  Widget _buildErrorCard(bool isDark, String error) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '获取天气失败',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '点击刷新获取天气',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
  
  Widget _buildWeatherCard(bool isDark, dynamic weather) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100, // 严格控制高度，确保不溢出
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 城市名 - 左上角
          Positioned(
            top: 12,
            left: 12,
            child: Text(
              weather.city,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ),
          ),
          
          // 温度 - 中心
          Positioned(
            top: 30,
            left: 12,
            child: Text(
              '${weather.temperature}°',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
              ),
            ),
          ),
          
          // 天气状况 - 左下角
          Positioned(
            bottom: 12,
            left: 12,
            child: Text(
              weather.weatherCondition,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ),
          ),
          
          // 刷新按钮 - 右上角
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              onPressed: onRefresh,
              icon: Icon(
                Icons.refresh,
                size: 16,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 16,
            ),
          ),
        ],
      ),
    );
  }


}