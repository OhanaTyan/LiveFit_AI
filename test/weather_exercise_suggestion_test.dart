import 'package:flutter_test/flutter_test.dart';
import 'package:life_fit/src/features/weather/domain/models/weather_data.dart';
import 'package:life_fit/src/features/weather/domain/models/exercise_recommendation.dart';
import 'package:life_fit/src/features/weather/utils/exercise_suitability_calculator.dart';

void main() {
  group('Exercise Suitability Calculator Tests', () {
    // 测试场景1：晴天，适宜温度
    test('Sunny day with moderate temperature', () {
      final weather = WeatherData(
        city: '北京',
        temperature: 22.0,
        weatherCondition: '晴天',
        humidity: 50,
        windSpeed: 2.5,
        windDirection: '北',
        pressure: 1013,
        iconCode: '01d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.verySuitable));
      expect(recommendation.isOutdoorRecommended, true);
      expect(recommendation.suitableExercises.isNotEmpty, true);
      expect(recommendation.weatherAlertKey, '');
    });

    // 测试场景2：雨天
    test('Rainy day', () {
      final weather = WeatherData(
        city: '上海',
        temperature: 18.0,
        weatherCondition: '小雨',
        humidity: 85,
        windSpeed: 3.0,
        windDirection: '东南',
        pressure: 1008,
        iconCode: '10d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable));
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertRain');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景3：雪天
    test('Snowy day', () {
      final weather = WeatherData(
        city: '哈尔滨',
        temperature: -5.0,
        weatherCondition: '雪',
        humidity: 70,
        windSpeed: 4.0,
        windDirection: '西北',
        pressure: 1015,
        iconCode: '13d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable));
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertSnow');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景4：高温天气
    test('High temperature', () {
      final weather = WeatherData(
        city: '广州',
        temperature: 38.0,
        weatherCondition: '晴天',
        humidity: 65,
        windSpeed: 1.5,
        windDirection: '南',
        pressure: 1005,
        iconCode: '01d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable));
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertHighTemp');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景5：低温天气
    test('Low temperature', () {
      final weather = WeatherData(
        city: '长春',
        temperature: -15.0,
        weatherCondition: '晴天',
        humidity: 40,
        windSpeed: 5.0,
        windDirection: '东北',
        pressure: 1020,
        iconCode: '01d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable));
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertLowTemp');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景6：适中温度，多云
    test('Cloudy day with moderate temperature', () {
      final weather = WeatherData(
        city: '杭州',
        temperature: 20.0,
        weatherCondition: '多云',
        humidity: 60,
        windSpeed: 3.5,
        windDirection: '东',
        pressure: 1010,
        iconCode: '03d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.verySuitable)); // 调整预期，因为温度适宜且风力小
      expect(recommendation.isOutdoorRecommended, true);
      expect(recommendation.suitableExercises.isNotEmpty, true);
      expect(recommendation.weatherAlertKey, '');
    });

    // 测试场景7：大风天气
    test('Windy day', () {
      final weather = WeatherData(
        city: '青岛',
        temperature: 25.0,
        weatherCondition: '晴天',
        humidity: 55,
        windSpeed: 12.0,
        windDirection: '东南',
        pressure: 1000,
        iconCode: '01d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable)); // 调整预期，因为风力过大
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertHighWind');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景8：极强风天气
    test('Very windy day', () {
      final weather = WeatherData(
        city: '青岛',
        temperature: 25.0,
        weatherCondition: '晴天',
        humidity: 55,
        windSpeed: 15.0, // 极强风
        windDirection: '东南',
        pressure: 1000,
        iconCode: '01d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.unsuitable));
      expect(recommendation.isOutdoorRecommended, false);
      expect(recommendation.weatherAlertKey, 'weatherAlertHighWind');
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });

    // 测试场景8：潮湿天气
    test('Humid day', () {
      final weather = WeatherData(
        city: '成都',
        temperature: 28.0,
        weatherCondition: '多云',
        humidity: 90,
        windSpeed: 2.0,
        windDirection: '西南',
        pressure: 1002,
        iconCode: '02d',
        lastUpdated: DateTime.now(),
      );

      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      expect(recommendation.suitability, equals(ExerciseSuitability.moderatelySuitable));
      expect(recommendation.isOutdoorRecommended, true);
      expect(recommendation.suitableExercises.isNotEmpty, true);
    });
  });
}
