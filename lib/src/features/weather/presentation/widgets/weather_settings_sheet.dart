import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';

class WeatherSettingsSheet extends StatefulWidget {
  final WeatherProvider weatherProvider;
  final VoidCallback onClose;

  const WeatherSettingsSheet({
    super.key,
    required this.weatherProvider,
    required this.onClose,
  });

  @override
  State<WeatherSettingsSheet> createState() => _WeatherSettingsSheetState();
}

class _WeatherSettingsSheetState extends State<WeatherSettingsSheet> {
  late String _selectedUnit;
  late int _selectedInterval;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.weatherProvider.temperatureUnit;
    _selectedInterval = widget.weatherProvider.updateInterval;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark ? GradientColors.backgroundDark : GradientColors.card,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '天气设置',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 温度单位设置
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '温度单位',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildUnitOption('摄氏度 (°C)', 'celsius'),
                  const SizedBox(width: 12),
                  _buildUnitOption('华氏度 (°F)', 'fahrenheit'),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 更新频率设置
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '更新频率',
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildIntervalOption(15),
                  _buildIntervalOption(30),
                  _buildIntervalOption(60),
                  _buildIntervalOption(120),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 保存按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '保存设置',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUnitOption(String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedUnit == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedUnit = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.2)
                : isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.borderLight
                      : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : isDark
                      ? AppColors.textSecondary
                      : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntervalOption(int minutes) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = _selectedInterval == minutes;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedInterval = minutes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : isDark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDark
                    ? AppColors.borderLight
                    : AppColors.borderLight,
            width: 1,
          ),
        ),
        child: Text(
          '$minutes 分钟',
          style: TextStyle(
            color: isSelected
                ? AppColors.primary
                : isDark
                    ? AppColors.textSecondary
                    : AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    widget.weatherProvider.setTemperatureUnit(_selectedUnit);
    widget.weatherProvider.setUpdateInterval(_selectedInterval);
    widget.onClose();
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
