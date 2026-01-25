import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String iconCode) {
    switch (iconCode) {
      case '01d': // 晴天（白天）
        return Icons.sunny;
      case '01n': // 晴天（夜晚）
        return Icons.clear;
      case '02d': // 少云（白天）
        return Icons.cloud;
      case '02n': // 少云（夜晚）
        return Icons.cloud;
      case '03d': // 多云（白天）
      case '03n': // 多云（夜晚）
      case '04d': // 阴天（白天）
      case '04n': // 阴天（夜晚）
        return Icons.cloud;
      case '09d': // 小雨（白天）
      case '09n': // 小雨（夜晚）
        return Icons.water_drop;
      case '10d': // 雨（白天）
      case '10n': // 雨（夜晚）
        return Icons.water_drop;
      case '11d': // 雷雨（白天）
      case '11n': // 雷雨（夜晚）
        return Icons.thunderstorm;
      case '13d': // 雪（白天）
      case '13n': // 雪（夜晚）
        return Icons.ac_unit;
      case '50d': // 雾（白天）
      case '50n': // 雾（夜晚）
        return Icons.cloud;
      default:
        return Icons.cloud;
    }
  }

  static Color getIconColor(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Colors.yellow;
      case '01n':
        return Colors.blue[300]!;
      case '02d':
        return Colors.yellow;
      case '02n':
        return Colors.blue[300]!;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Colors.grey;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Colors.blue;
      case '11d':
      case '11n':
        return Colors.purple;
      case '13d':
      case '13n':
        return Colors.lightBlue;
      case '50d':
      case '50n':
        return Colors.grey[400]!;
      default:
        return Colors.grey;
    }
  }
}
