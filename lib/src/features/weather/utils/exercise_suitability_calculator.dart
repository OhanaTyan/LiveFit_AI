import '../domain/models/weather_data.dart';
import '../domain/models/exercise_recommendation.dart';

class ExerciseSuitabilityCalculator {
  static ExerciseRecommendation calculateSuitability(WeatherData weather) {
    final temp = weather.temperature;
    final humidity = weather.humidity;
    final windSpeed = weather.windSpeed;
    final weatherCondition = weather.weatherCondition.toLowerCase();
    final aqi = weather.aqi;
    final uvIndex = weather.uvIndex;

    // 计算适宜度分数
    int score = 100;

    // 温度影响（进一步调整权重）
    if (temp < -10) {
      score -= 80;
    } else if (temp < 0) {
      score -= 60;
    } else if (temp < 10) {
      score -= 40;
    } else if (temp > 35) {
      score -= 80;
    } else if (temp > 30) {
      score -= 50;
    } else if (temp >= 15 && temp <= 25) {
      // 最适宜的温度范围
      score += 10;
    }

    // 湿度影响（调整权重）
    if (humidity > 85) {
      score -= 30;
    } else if (humidity > 75) {
      score -= 20;
    } else if (humidity < 20) {
      score -= 20;
    } else if (humidity < 30) {
      score -= 10;
    }

    // 风力影响（进一步调整权重）
    if (windSpeed > 10) {
      score -= 100; // 大幅增加扣分，确保大风天气被识别为不适宜
    } else if (windSpeed > 7) {
      score -= 50;
    } else if (windSpeed > 5) {
      score -= 25;
    }

    // 空气质量指数(AQI)影响
    if (aqi != null) {
      if (aqi > 300) {
        score -= 80; // 严重污染
      } else if (aqi > 200) {
        score -= 60; // 重度污染
      } else if (aqi > 150) {
        score -= 40; // 中度污染
      } else if (aqi > 100) {
        score -= 20; // 轻度污染
      } else if (aqi > 50) {
        score -= 10; // 良
      }
      // AQI <= 50 为优，不扣分
    }

    // 紫外线指数(UV Index)影响
    if (uvIndex != null) {
      if (uvIndex > 11) {
        score -= 60; // 极端
      } else if (uvIndex > 8) {
        score -= 40; // 很强
      } else if (uvIndex > 6) {
        score -= 25; // 强
      } else if (uvIndex > 3) {
        score -= 10; // 中等
      }
      // UV Index <= 3 为弱，不扣分
    }

    // 天气状况影响（调整权重）
    if (weatherCondition.contains('雨')) {
      score -= 60;
    } else if (weatherCondition.contains('雪')) {
      score -= 60;
    } else if (weatherCondition.contains('雾')) {
      score -= 50;
    } else if (weatherCondition.contains('霾')) {
      score -= 50;
    } else if (weatherCondition.contains('晴')) {
      score += 10;
    }

    // 确定适宜度等级（调整阈值）
    late ExerciseSuitability suitability;
    late String recommendationKey;
    late List<String> suitableExercises;
    late List<String> unsuitableExercises;
    late String weatherAlertKey;
    late bool isOutdoorRecommended;

    if (score >= 95) {
      suitability = ExerciseSuitability.verySuitable;
      recommendationKey = 'weatherRecommendationVerySuitable';
      suitableExercises = ['aerobicExerciseRunning', 'aerobicExerciseCycling', 'aerobicExerciseHiking', 'aerobicExerciseFootball', 'aerobicExerciseBasketball', 'aerobicExerciseTennis'];
      unsuitableExercises = [];
      weatherAlertKey = '';
      isOutdoorRecommended = true;
    } else if (score >= 75) {
      suitability = ExerciseSuitability.suitable;
      recommendationKey = 'weatherRecommendationSuitable';
      suitableExercises = ['aerobicExerciseRunning', 'aerobicExerciseCycling', 'aerobicExerciseHiking', 'aerobicExerciseYoga'];
      unsuitableExercises = [];
      weatherAlertKey = '';
      isOutdoorRecommended = true;
    } else if (score >= 50) {
      suitability = ExerciseSuitability.moderatelySuitable;
      recommendationKey = 'weatherRecommendationModeratelySuitable';
      suitableExercises = ['weatherExerciseLightRunning', 'aerobicExerciseYoga', 'aerobicExerciseAerobics'];
      unsuitableExercises = ['weatherExerciseHighIntensity', 'weatherExerciseLongOutdoor'];
      weatherAlertKey = '';
      isOutdoorRecommended = true;
    } else {
      suitability = ExerciseSuitability.unsuitable;
      recommendationKey = 'weatherRecommendationUnsuitable';
      suitableExercises = ['weatherExerciseIndoorRunning', 'aerobicExerciseYoga', 'aerobicExerciseAerobics', 'weatherExerciseStrengthTraining', 'aerobicExerciseSwimming'];
      unsuitableExercises = ['weatherExerciseAllOutdoor'];
      weatherAlertKey = _getWeatherAlertKey(weatherCondition, temp, windSpeed);
      isOutdoorRecommended = false;
    }

    return ExerciseRecommendation(
      suitability: suitability,
      recommendationKey: recommendationKey,
      suitableExercises: suitableExercises,
      unsuitableExercises: unsuitableExercises,
      weatherAlertKey: weatherAlertKey,
      isOutdoorRecommended: isOutdoorRecommended,
    );
  }

  static String _getWeatherAlertKey(String condition, double temp, double windSpeed) {
    if (condition.contains('雨')) {
      return 'weatherAlertRain';
    } else if (condition.contains('雪')) {
      return 'weatherAlertSnow';
    } else if (condition.contains('雾') || condition.contains('霾')) {
      return 'weatherAlertLowVisibility';
    } else if (temp < 0) {
      return 'weatherAlertLowTemp';
    } else if (temp > 35) {
      return 'weatherAlertHighTemp';
    } else if (windSpeed > 10) {
      return 'weatherAlertHighWind';
    }
    return '';
  }

  static String getSuitabilityColor(ExerciseSuitability suitability) {
    switch (suitability) {
      case ExerciseSuitability.verySuitable:
        return '#4CAF50'; // 绿色
      case ExerciseSuitability.suitable:
        return '#8BC34A'; // 浅绿色
      case ExerciseSuitability.moderatelySuitable:
        return '#FFC107'; // 黄色
      case ExerciseSuitability.unsuitable:
        return '#F44336'; // 红色
    }
  }
}
