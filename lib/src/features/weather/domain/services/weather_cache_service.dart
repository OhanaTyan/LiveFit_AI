import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';
import '../models/forecast_data.dart';
import '../models/exercise_recommendation.dart';

class WeatherCacheService {
  static const String currentWeatherKey = 'current_weather';
  static const String forecastKey = 'weather_forecast';
  static const String recommendationKey = 'exercise_recommendation';
  static const String lastUpdateKey = 'last_weather_update';
  static const String cityKey = 'selected_city';
  static const String temperatureUnitKey = 'temperature_unit';
  static const String updateIntervalKey = 'update_interval';

  final SharedPreferences prefs;

  WeatherCacheService({required this.prefs});

  Future<void> cacheCurrentWeather(WeatherData weather) async {
    await prefs.setString(currentWeatherKey, jsonEncode(weather.toMap()));
    await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
  }

  WeatherData? getCachedCurrentWeather() {
    final data = prefs.getString(currentWeatherKey);
    if (data == null) return null;
    
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return WeatherData.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheForecast(ForecastList forecast) async {
    await prefs.setString(forecastKey, jsonEncode(forecast.toMap()));
  }

  ForecastList? getCachedForecast() {
    final data = prefs.getString(forecastKey);
    if (data == null) return null;
    
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return ForecastList.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  Future<void> cacheExerciseRecommendation(ExerciseRecommendation recommendation) async {
    await prefs.setString(recommendationKey, jsonEncode(recommendation.toMap()));
  }

  ExerciseRecommendation? getCachedExerciseRecommendation() {
    final data = prefs.getString(recommendationKey);
    if (data == null) return null;
    
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return ExerciseRecommendation.fromMap(map);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveSelectedCity(String city) async {
    await prefs.setString(cityKey, city);
  }

  String? getSelectedCity() {
    return prefs.getString(cityKey);
  }

  Future<void> saveTemperatureUnit(String unit) async {
    await prefs.setString(temperatureUnitKey, unit);
  }

  String getTemperatureUnit() {
    return prefs.getString(temperatureUnitKey) ?? 'celsius';
  }

  Future<void> saveUpdateInterval(int minutes) async {
    await prefs.setInt(updateIntervalKey, minutes);
  }

  int getUpdateInterval() {
    return prefs.getInt(updateIntervalKey) ?? 30;
  }

  bool isCacheValid() {
    final lastUpdate = prefs.getString(lastUpdateKey);
    if (lastUpdate == null) return false;
    
    final updateTime = DateTime.parse(lastUpdate);
    final now = DateTime.now();
    final interval = getUpdateInterval();
    
    return now.difference(updateTime).inMinutes < interval;
  }

  Future<void> clearCache() async {
    await prefs.remove(currentWeatherKey);
    await prefs.remove(forecastKey);
    await prefs.remove(recommendationKey);
    await prefs.remove(lastUpdateKey);
  }


}
