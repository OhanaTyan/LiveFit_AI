import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/forecast_data.dart';

class WeatherApiService {
  static const String baseUrl =
      'https://api.open-meteo.com/v1'; // Open-Meteo API基础URL
  static const String units = 'metric'; // 使用摄氏度

  final http.Client client;

  WeatherApiService({required this.client});

  // 获取实时天气数据
  Future<WeatherData> getCurrentWeather(
    double lat,
    double lon,
    String city,
  ) async {
    int retryCount = 0;
    const maxRetries = 2;
    const timeoutSeconds = 10;

    while (retryCount <= maxRetries) {
      try {
        final url =
            '$baseUrl/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,wind_direction_10m,pressure_msl&timezone=Asia/Shanghai&forecast_days=1';

        final response = await client
            .get(
              Uri.parse(url),
              headers: {
                'User-Agent': 'LifeFit/1.0',
                'Accept': 'application/json',
              },
            )
            .timeout(Duration(seconds: timeoutSeconds));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // 构建WeatherData对象
          return WeatherData(
            city: city,
            temperature: data['current']['temperature_2m'],
            weatherCondition: _getWeatherCondition(
              data['current']['weather_code'].toInt(),
            ),
            humidity: data['current']['relative_humidity_2m'].toInt(),
            windSpeed: data['current']['wind_speed_10m'],
            windDirection: _getWindDirection(
              data['current']['wind_direction_10m'].toInt(),
            ),
            pressure: data['current']['pressure_msl'].toInt(),
            iconCode: data['current']['weather_code'].toString(),
            lastUpdated: DateTime.now(),
            aqi: null, // Open-Meteo不提供AQI数据
            uvIndex: null, // Open-Meteo不提供UV指数
          );
        } else {
          throw Exception('获取天气数据失败: ${response.statusCode}');
        }
      } catch (e) {
        retryCount++;
        if (retryCount <= maxRetries) {
          // 等待后重试
          await Future.delayed(Duration(seconds: 2 * retryCount));
          continue;
        }
        throw Exception('获取天气数据时出错: $e');
      }
    }
    // 理论上不会到达这里
    throw Exception('获取天气数据时出错: 未知错误');
  }

  // 获取天气预报数据
  Future<ForecastList> getWeatherForecast(double lat, double lon) async {
    int retryCount = 0;
    const maxRetries = 2;
    const timeoutSeconds = 10;

    while (retryCount <= maxRetries) {
      try {
        final url =
            '$baseUrl/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=Asia/Shanghai&forecast_days=3';

        final response = await client
            .get(
              Uri.parse(url),
              headers: {
                'User-Agent': 'LifeFit/1.0',
                'Accept': 'application/json',
              },
            )
            .timeout(Duration(seconds: timeoutSeconds));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // 构建ForecastData列表
          final forecasts = <ForecastData>[];
          for (int i = 0; i < data['daily']['time'].length; i++) {
            forecasts.add(
              ForecastData(
                date: data['daily']['time'][i],
                maxTemperature: data['daily']['temperature_2m_max'][i],
                minTemperature: data['daily']['temperature_2m_min'][i],
                weatherCondition: _getWeatherCondition(
                  data['daily']['weather_code'][i].toInt(),
                ),
                iconCode: data['daily']['weather_code'][i].toString(),
              ),
            );
          }

          return ForecastList(
            forecasts: forecasts,
            lastUpdated: DateTime.now(),
          );
        } else {
          throw Exception('获取天气预报失败: ${response.statusCode}');
        }
      } catch (e) {
        retryCount++;
        if (retryCount <= maxRetries) {
          // 等待后重试
          await Future.delayed(Duration(seconds: 2 * retryCount));
          continue;
        }
        throw Exception('获取天气预报时出错: $e');
      }
    }
    // 理论上不会到达这里
    throw Exception('获取天气预报时出错: 未知错误');
  }

  // 使用Nominatim API进行地理编码，根据城市名称获取经纬度
  Future<(double, double)> _getCoordinatesByCity(String cityName) async {
    int retryCount = 0;
    const maxRetries = 2;
    const timeoutSeconds = 10;

    while (retryCount <= maxRetries) {
      try {
        final encodedCity = Uri.encodeComponent(cityName);
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$encodedCity&format=json&limit=1&accept-language=zh-CN',
        );

        final response = await client
            .get(url, headers: {'User-Agent': 'LifeFit/1.0'})
            .timeout(Duration(seconds: timeoutSeconds));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            final double lat = double.parse(data[0]['lat']);
            final double lon = double.parse(data[0]['lon']);
            return (lat, lon);
          } else {
            // 如果没有找到城市，返回默认位置（北京）
            return (39.9042, 116.4074);
          }
        } else {
          // API请求失败，返回默认位置（北京）
          return (39.9042, 116.4074);
        }
      } catch (e) {
        retryCount++;
        if (retryCount <= maxRetries) {
          // 等待后重试
          await Future.delayed(Duration(seconds: 2 * retryCount));
          continue;
        }
        // 网络请求失败，返回默认位置（北京）
        return (39.9042, 116.4074);
      }
    }
    // 理论上不会到达这里
    return (39.9042, 116.4074);
  }

  // 根据城市名称获取实时天气
  Future<WeatherData> getCurrentWeatherByCity(String cityName) async {
    final (lat, lon) = await _getCoordinatesByCity(cityName);
    return getCurrentWeather(lat, lon, cityName);
  }

  // 根据城市名称获取天气预报
  Future<ForecastList> getWeatherForecastByCity(String cityName) async {
    final (lat, lon) = await _getCoordinatesByCity(cityName);
    return getWeatherForecast(lat, lon);
  }

  // 将Open-Meteo天气代码转换为天气状况描述
  String _getWeatherCondition(int weatherCode) {
    // 天气代码映射表，参考Open-Meteo文档
    if (weatherCode == 0) return '晴天';
    if (weatherCode >= 1 && weatherCode <= 3) return '多云';
    if (weatherCode >= 45 && weatherCode <= 48) return '雾';
    if (weatherCode >= 51 && weatherCode <= 55) return '小雨';
    if (weatherCode >= 56 && weatherCode <= 57) return '冻雨';
    if (weatherCode >= 61 && weatherCode <= 65) return '中雨';
    if (weatherCode >= 66 && weatherCode <= 67) return '冻雨';
    if (weatherCode >= 71 && weatherCode <= 75) return '小雪';
    if (weatherCode == 77) return '雪';
    if (weatherCode >= 80 && weatherCode <= 82) return '阵雨';
    if (weatherCode >= 85 && weatherCode <= 86) return '阵雪';
    if (weatherCode >= 95 && weatherCode <= 99) return '雷暴';
    return '未知';
  }

  // 将风向角度转换为风向描述
  String _getWindDirection(int degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return '北风';
    if (degrees >= 22.5 && degrees < 67.5) return '东北风';
    if (degrees >= 67.5 && degrees < 112.5) return '东风';
    if (degrees >= 112.5 && degrees < 157.5) return '东南风';
    if (degrees >= 157.5 && degrees < 202.5) return '南风';
    if (degrees >= 202.5 && degrees < 247.5) return '西南风';
    if (degrees >= 247.5 && degrees < 292.5) return '西风';
    if (degrees >= 292.5 && degrees < 337.5) return '西北风';
    return '未知';
  }
}
