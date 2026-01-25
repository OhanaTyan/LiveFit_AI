class WeatherData {
  final String city;
  final double temperature;
  final String weatherCondition;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int pressure;
  final String iconCode;
  final DateTime lastUpdated;
  final int? aqi; // 空气质量指数
  final double? uvIndex; // 紫外线指数

  WeatherData({
    required this.city,
    required this.temperature,
    required this.weatherCondition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.iconCode,
    required this.lastUpdated,
    this.aqi,
    this.uvIndex,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String city) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return WeatherData(
      city: city,
      temperature: main['temp'].toDouble(),
      weatherCondition: weather['description'],
      humidity: main['humidity'],
      windSpeed: wind['speed'].toDouble(),
      windDirection: _getWindDirection(wind['deg']),
      pressure: main['pressure'],
      iconCode: weather['icon'],
      lastUpdated: DateTime.now(),
      // AQI和UV指数将通过单独的API请求获取
      aqi: json['air_quality']?['aqi'] as int?,
      uvIndex: json['uv']?['value'] as double?,
    );
  }

  static String _getWindDirection(int degrees) {
    const directions = ['北', '东北', '东', '东南', '南', '西南', '西', '西北'];
    final index = ((degrees % 360) / 45).round() % 8;
    return directions[index];
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'temperature': temperature,
      'weatherCondition': weatherCondition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'iconCode': iconCode,
      'lastUpdated': lastUpdated.toIso8601String(),
      'aqi': aqi,
      'uvIndex': uvIndex,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      city: map['city'],
      temperature: map['temperature'],
      weatherCondition: map['weatherCondition'],
      humidity: map['humidity'],
      windSpeed: map['windSpeed'],
      windDirection: map['windDirection'],
      pressure: map['pressure'],
      iconCode: map['iconCode'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
      aqi: map['aqi'],
      uvIndex: map['uvIndex'],
    );
  }
}
