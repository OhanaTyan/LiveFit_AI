import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/utils/weather_icons.dart';
import '../../../weather/utils/temperature_converter.dart';

class WeatherExpandedCard extends StatelessWidget {
  final WeatherProvider weatherProvider;
  final VoidCallback onRefresh;
  final VoidCallback onCollapse;

  const WeatherExpandedCard({
    super.key,
    required this.weatherProvider,
    required this.onRefresh,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final weather = weatherProvider.currentWeather;
    final forecast = weatherProvider.forecast;

    if (weather == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头部：城市名和操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weather.city,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh, size: 20),
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    ),
                    IconButton(
                      onPressed: onCollapse,
                      icon: const Icon(Icons.expand_less, size: 20),
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 当前天气概览
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TemperatureConverter.formatTemperature(
                        weather.temperature,
                        weatherProvider.temperatureUnit,
                      ),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.weatherCondition,
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
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
            const SizedBox(height: 16),
            
            // 核心气象参数
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  isDark, 
                  Icons.thermostat_outlined, 
                  '体感温度',
                  TemperatureConverter.formatTemperature(
                    weather.temperature,
                    weatherProvider.temperatureUnit,
                  ),
                ),
                _buildDetailItem(
                  isDark, 
                  Icons.water_drop_outlined, 
                  '湿度',
                  '${weather.humidity}%',
                ),
                _buildDetailItem(
                  isDark, 
                  Icons.air, 
                  '风速',
                  '${weather.windSpeed} m/s',
                ),
                _buildDetailItem(
                  isDark, 
                  Icons.compass_calibration_outlined, 
                  '气压',
                  '${weather.pressure} hPa',
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 空气质量指数
            _buildAQISection(isDark, weather),
            const SizedBox(height: 24),
            
            // 24小时预报
            _buildHourlyForecast(isDark, weather, forecast),
            const SizedBox(height: 24),
            
            // 5天预报
            _buildDailyForecast(isDark, forecast),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(bool isDark, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildAQISection(bool isDark, dynamic weather) {
    // 模拟AQI数据
    final aqi = 75;
    final aqiLevel = _getAQILevel(aqi);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '空气质量',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: aqiLevel.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'AQI $aqi',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              aqiLevel.description,
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHourlyForecast(bool isDark, dynamic weather, dynamic forecast) {
    // 模拟24小时预报数据
    final hourlyData = List.generate(12, (index) {
      final hour = DateTime.now().hour + index * 2;
      return {
        'time': '${hour % 24}:00',
        'temp': weather.temperature + (index - 6) * 2,
        'iconCode': weather.iconCode,
        'precipitation': (index % 4) * 10,
      };
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '24小时预报',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // 设置固定高度
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: hourlyData.length,
            itemBuilder: (context, index) {
              final item = hourlyData[index];
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Text(
                      item['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      WeatherIcons.getIcon(item['iconCode']),
                      size: 32,
                      color: WeatherIcons.getIconColor(item['iconCode']),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      TemperatureConverter.formatTemperature(
                        item['temp'],
                        weatherProvider.temperatureUnit,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.opacity,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item['precipitation']}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast(bool isDark, dynamic forecast) {
    // 使用实际预报数据或模拟数据
    final dailyData = forecast != null && forecast.forecasts.isNotEmpty
        ? forecast.forecasts
        : List.generate(5, (index) {
            final date = DateTime.now().add(Duration(days: index + 1));
            return {
              'date': '周${_getWeekday(date.weekday)}',
              'iconCode': '01d',
              'maxTemp': 25 + index,
              'minTemp': 15 + index,
            };
          });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5天预报',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: dailyData.map<Widget>((item) {
            // 修复：检查item类型，避免dynamic调用错误
            final date = item is Map<String, dynamic> ? item['date'] : item?.date;
            final iconCode = item is Map<String, dynamic> ? item['iconCode'] : item?.iconCode;
            final maxTemp = item is Map<String, dynamic> ? item['maxTemp'] : item?.maxTemperature;
            final minTemp = item is Map<String, dynamic> ? item['minTemp'] : item?.minTemperature;
            
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    ),
                  ),
                  Icon(
                    WeatherIcons.getIcon(iconCode ?? '01d'),
                    size: 24,
                    color: WeatherIcons.getIconColor(iconCode ?? '01d'),
                  ),
                  Row(
                    children: [
                      Text(
                        TemperatureConverter.formatTemperature(
                          maxTemp ?? 25,
                          weatherProvider.temperatureUnit,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        TemperatureConverter.formatTemperature(
                          minTemp ?? 15,
                          weatherProvider.temperatureUnit,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    return weekdays[weekday % 7];
  }

  _AQILevel _getAQILevel(int aqi) {
    if (aqi <= 50) {
      return _AQILevel('优', Colors.green);
    } else if (aqi <= 100) {
      return _AQILevel('良', Colors.yellow);
    } else if (aqi <= 150) {
      return _AQILevel('轻度污染', Colors.orange);
    } else if (aqi <= 200) {
      return _AQILevel('中度污染', Colors.red);
    } else if (aqi <= 300) {
      return _AQILevel('重度污染', Colors.purple);
    } else {
      return _AQILevel('严重污染', Colors.brown);
    }
  }
}

class _AQILevel {
  final String description;
  final Color color;

  _AQILevel(this.description, this.color);
}