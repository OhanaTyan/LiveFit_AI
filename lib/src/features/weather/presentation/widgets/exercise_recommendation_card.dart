import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/utils/exercise_suitability_calculator.dart';
import '../../../weather/domain/models/exercise_recommendation.dart';
import '../../../../core/localization/app_localizations.dart';

class ExerciseRecommendationCard extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const ExerciseRecommendationCard({
    super.key,
    required this.weatherProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recommendation = weatherProvider.exerciseRecommendation;
    final l10n = AppLocalizations.of(context);
    
    if (recommendation == null || l10n == null) {
      return const SizedBox.shrink();
    }

    final suitabilityColorStr = ExerciseSuitabilityCalculator.getSuitabilityColor(
      recommendation.suitability,
    );
    final suitabilityColor = Color(int.parse(suitabilityColorStr.replaceAll('#', '0xFF')));

    // Get localized suitability text
    String getSuitabilityText() {
      if (recommendation.suitability == ExerciseSuitability.verySuitable) {
        return l10n.weatherSuitabilityVerySuitable;
      } else if (recommendation.suitability == ExerciseSuitability.suitable) {
        return l10n.weatherSuitabilitySuitable;
      } else if (recommendation.suitability == ExerciseSuitability.moderatelySuitable) {
        return l10n.weatherSuitabilityModeratelySuitable;
      } else {
        return l10n.weatherSuitabilityUnsuitable;
      }
    }

    // Get localized string for a given key
    String getLocalizedString(String key) {
      return l10n.getLocalizedString(key);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.exerciseRecommendation,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: suitabilityColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getSuitabilityText(),
                  style: TextStyle(
                    color: suitabilityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 天气预警
          if (recommendation.weatherAlertKey.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      getLocalizedString(recommendation.weatherAlertKey),
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // 推荐语
          Text(
            getLocalizedString(recommendation.recommendationKey),
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
              fontSize: 14,
            ),
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          
          const SizedBox(height: 16),
          
          // 适宜的运动
          if (recommendation.suitableExercises.isNotEmpty) ...[
            Text(
              l10n.recommendedSports,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recommendation.suitableExercises.map((exerciseKey) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      getLocalizedString(exerciseKey),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // 不适宜的运动
          if (recommendation.unsuitableExercises.isNotEmpty) ...[
            Text(
              l10n.notRecommended,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.textPrimaryLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recommendation.unsuitableExercises.map((exerciseKey) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      getLocalizedString(exerciseKey),
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // 锻炼类型建议
          Row(
            children: [
              Icon(
                recommendation.isOutdoorRecommended
                    ? Icons.outdoor_grill_outlined
                    : Icons.fitness_center_outlined,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recommendation.isOutdoorRecommended
                      ? l10n.suggestOutdoorActivity : l10n.suggestIndoorActivity,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
