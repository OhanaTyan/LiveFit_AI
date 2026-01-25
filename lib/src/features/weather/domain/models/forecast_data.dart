class ForecastData {
  final String date;
  final double maxTemperature;
  final double minTemperature;
  final String weatherCondition;
  final String iconCode;

  ForecastData({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
    required this.iconCode,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);

    return ForecastData(
      date: '${date.month}/${date.day}',
      maxTemperature: main['temp_max'].toDouble(),
      minTemperature: main['temp_min'].toDouble(),
      weatherCondition: weather['description'],
      iconCode: weather['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'maxTemperature': maxTemperature,
      'minTemperature': minTemperature,
      'weatherCondition': weatherCondition,
      'iconCode': iconCode,
    };
  }

  factory ForecastData.fromMap(Map<String, dynamic> map) {
    return ForecastData(
      date: map['date'],
      maxTemperature: map['maxTemperature'],
      minTemperature: map['minTemperature'],
      weatherCondition: map['weatherCondition'],
      iconCode: map['iconCode'],
    );
  }
}

class ForecastList {
  final List<ForecastData> forecasts;
  final DateTime lastUpdated;

  ForecastList({
    required this.forecasts,
    required this.lastUpdated,
  });

  factory ForecastList.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List;
    final forecasts = list.map((item) => ForecastData.fromJson(item)).toList();
    
    // 按日期分组，取每天的最高最低温度
    final dailyForecasts = _groupByDate(forecasts);

    return ForecastList(
      forecasts: dailyForecasts,
      lastUpdated: DateTime.now(),
    );
  }

  static List<ForecastData> _groupByDate(List<ForecastData> forecasts) {
    final Map<String, List<ForecastData>> grouped = {};

    for (final forecast in forecasts) {
      if (!grouped.containsKey(forecast.date)) {
        grouped[forecast.date] = [];
      }
      grouped[forecast.date]!.add(forecast);
    }

    final List<ForecastData> dailyForecasts = [];
    grouped.forEach((date, dayForecasts) {
      double maxTemp = dayForecasts.map((f) => f.maxTemperature).reduce((a, b) => a > b ? a : b);
      double minTemp = dayForecasts.map((f) => f.minTemperature).reduce((a, b) => a < b ? a : b);
      
      dailyForecasts.add(ForecastData(
        date: date,
        maxTemperature: maxTemp,
        minTemperature: minTemp,
        weatherCondition: dayForecasts.first.weatherCondition,
        iconCode: dayForecasts.first.iconCode,
      ));
    });

    // 只返回前5天的预报
    return dailyForecasts.take(5).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'forecasts': forecasts.map((f) => f.toMap()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ForecastList.fromMap(Map<String, dynamic> map) {
    final forecasts = (map['forecasts'] as List)
        .map((f) => ForecastData.fromMap(f))
        .toList();

    return ForecastList(
      forecasts: forecasts,
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}
