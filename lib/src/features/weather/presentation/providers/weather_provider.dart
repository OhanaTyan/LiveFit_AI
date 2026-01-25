import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/weather_data.dart';
import '../../domain/models/forecast_data.dart';
import '../../domain/models/exercise_recommendation.dart';
import '../../domain/services/weather_api_service.dart';
import '../../domain/services/weather_cache_service.dart';
import '../../domain/services/location_service.dart';
import '../../utils/exercise_suitability_calculator.dart';
import '../../../../core/services/log_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherData? _currentWeather;
  ForecastList? _forecast;
  ExerciseRecommendation? _exerciseRecommendation;
  bool _isLoading = false;
  String? _error;
  String _temperatureUnit = 'celsius';
  int _updateInterval = 30; // 分钟

  late WeatherApiService _apiService;
  late WeatherCacheService _cacheService;
  late LocationService _locationService;
  Timer? _updateTimer;

  WeatherData? get currentWeather => _currentWeather;
  ForecastList? get forecast => _forecast;
  ExerciseRecommendation? get exerciseRecommendation => _exerciseRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get temperatureUnit => _temperatureUnit;
  int get updateInterval => _updateInterval;

  Future<void> initialize() async {
    log.debug('WeatherProvider: 开始初始化');
    final prefs = await SharedPreferences.getInstance();
    final client = http.Client();

    _apiService = WeatherApiService(client: client);
    _cacheService = WeatherCacheService(prefs: prefs);
    _locationService = LocationService();
    log.debug('WeatherProvider: 服务初始化完成');

    // 加载保存的设置
    _temperatureUnit = _cacheService.getTemperatureUnit();
    _updateInterval = _cacheService.getUpdateInterval();
    log.debug('WeatherProvider: 加载设置完成');

    // 先加载缓存数据
    _loadCachedWeatherData();
    log.debug('WeatherProvider: 缓存天气数据加载完成');

    // 然后尝试获取最新天气数据
    await fetchWeatherData();
    log.debug('WeatherProvider: 初始天气数据加载完成');

    // 设置自动更新
    _setupAutoUpdate();
    log.debug('WeatherProvider: 自动更新设置完成');
  }

  void _loadCachedWeatherData() {
    final cachedWeather = _cacheService.getCachedCurrentWeather();
    final cachedForecast = _cacheService.getCachedForecast();
    final cachedRecommendation = _cacheService
        .getCachedExerciseRecommendation();

    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      log.debug('WeatherProvider: 加载缓存的当前天气数据');
    }

    if (cachedForecast != null) {
      _forecast = cachedForecast;
      log.debug('WeatherProvider: 加载缓存的天气预报数据');
    }

    if (cachedRecommendation != null) {
      _exerciseRecommendation = cachedRecommendation;
      log.debug('WeatherProvider: 加载缓存的运动建议数据');
    }

    // 通知监听器缓存数据已加载
    notifyListeners();
  }

  Future<void> fetchWeatherData() async {
    // 只有在没有正在加载时才开始新的请求
    if (_isLoading) {
      log.debug('WeatherProvider: 已经在加载天气数据，跳过请求');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    log.debug('WeatherProvider: 开始获取天气数据');

    try {
      // 获取位置数据
      log.debug('WeatherProvider: 开始获取位置数据');
      final (lat, lon, city) = await _locationService.getLocationData();
      log.debug('WeatherProvider: 位置数据获取成功: $lat, $lon, $city');

      // 并行获取当前天气和天气预报
      log.debug('WeatherProvider: 开始并行获取当前天气和天气预报');
      final weatherFuture = _apiService.getCurrentWeather(lat, lon, city);
      final forecastFuture = _apiService.getWeatherForecast(lat, lon);

      // 等待两个请求完成（带总超时）
      final results = await Future.wait([weatherFuture, forecastFuture])
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              log.debug('WeatherProvider: 获取天气数据超时');
              throw Exception('获取天气数据超时');
            },
          );

      final weather = results[0] as WeatherData;
      final forecast = results[1] as ForecastList;
      log.debug('WeatherProvider: 天气数据获取成功');

      // 计算锻炼建议
      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(
        weather,
      );

      // 更新状态
      _currentWeather = weather;
      _forecast = forecast;
      _exerciseRecommendation = recommendation;
      _error = null;
      log.debug('WeatherProvider: 状态更新完成');

      // 并行缓存数据（在后台执行，不阻塞UI）
      Future.wait([
        _cacheService.cacheCurrentWeather(weather),
        _cacheService.cacheForecast(forecast),
        _cacheService.cacheExerciseRecommendation(recommendation),
      ]).catchError((_) {
        log.debug('WeatherProvider: 缓存数据失败');
        return [];
      });
    } catch (e) {
      // 显示具体的错误信息，让用户知道获取位置失败的原因
      _error = '获取天气数据失败: $e';
      log.error('WeatherProvider: 获取天气数据失败: $e');

      // 如果没有当前天气数据且缓存也无效，设置默认天气数据
      if (_currentWeather == null || !_cacheService.isCacheValid()) {
        log.debug('WeatherProvider: 设置默认天气数据');
        _currentWeather = WeatherData(
          city: '北京',
          temperature: 20.0,
          weatherCondition: '晴天',
          humidity: 50,
          windSpeed: 5.0,
          windDirection: '北风',
          pressure: 1013,
          iconCode: '0',
          lastUpdated: DateTime.now(),
        );
        _forecast = ForecastList(
          forecasts: [
            ForecastData(
              date: DateTime.now().toIso8601String().split('T')[0],
              maxTemperature: 22.0,
              minTemperature: 18.0,
              weatherCondition: '晴天',
              iconCode: '0',
            ),
          ],
          lastUpdated: DateTime.now(),
        );
        _exerciseRecommendation = ExerciseRecommendation(
          suitability: ExerciseSuitability.verySuitable,
          recommendationKey: 'very_suitable',
          suitableExercises: ['跑步', '骑行', '羽毛球'],
          unsuitableExercises: [],
          weatherAlertKey: 'no_alert',
          isOutdoorRecommended: true,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      log.debug('WeatherProvider: 获取天气数据完成');
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    // 只有在没有正在加载时才开始新的请求
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 并行获取城市天气和天气预报
      final weatherFuture = _apiService.getCurrentWeatherByCity(city);
      final forecastFuture = _apiService.getWeatherForecastByCity(city);

      // 等待两个请求完成（带总超时）
      final results = await Future.wait([weatherFuture, forecastFuture])
          .timeout(
            Duration(seconds: 15),
            onTimeout: () {
              throw Exception('获取城市天气数据超时');
            },
          );

      final weather = results[0] as WeatherData;
      final forecast = results[1] as ForecastList;

      // 计算锻炼建议
      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(
        weather,
      );

      // 更新状态
      _currentWeather = weather;
      _forecast = forecast;
      _exerciseRecommendation = recommendation;

      // 并行缓存数据（在后台执行，不阻塞UI）
      Future.wait([
        _cacheService.cacheCurrentWeather(weather),
        _cacheService.cacheForecast(forecast),
        _cacheService.cacheExerciseRecommendation(recommendation),
        _cacheService.saveSelectedCity(city),
      ]).catchError((_) {
        return [];
      });
    } catch (e) {
      _error = '获取城市天气数据失败: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTemperatureUnit(String unit) {
    _temperatureUnit = unit;
    _cacheService.saveTemperatureUnit(unit);
    notifyListeners();
  }

  void setUpdateInterval(int minutes) {
    _updateInterval = minutes;
    _cacheService.saveUpdateInterval(minutes);
    _setupAutoUpdate();
    notifyListeners();
  }

  void _setupAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(Duration(minutes: _updateInterval), (timer) {
      fetchWeatherData();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
