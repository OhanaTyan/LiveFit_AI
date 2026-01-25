import 'dart:convert';
import 'package:flutter/services.dart';

// 注意：原导入 '../dart_models/aerobic_activity.dart' 在 lib 目录外无法正常工作
// 如果需要使用此服务，请将这些文件移至 lib/src 目录下
// 临时方案：内联 AerobicActivity 类定义
class AerobicActivity {
  final String category;
  final String variant;
  final double caloriesPerKgPerUnit;

  AerobicActivity({
    required this.category,
    required this.variant,
    required this.caloriesPerKgPerUnit,
  });

  factory AerobicActivity.fromJson(Map<String, dynamic> json) {
    return AerobicActivity(
      category: json['category'] ?? '',
      variant: json['variant'] ?? '',
      caloriesPerKgPerUnit: (json['calories_per_kg_per_unit'] as num).toDouble(),
    );
  }
}

class AerobicDataService {
  List<AerobicActivity> _activities = [];

  List<AerobicActivity> get activities => _activities;

  Future<void> loadData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/aerobic_data.json');
      final List<dynamic> data = json.decode(response);
      _activities = data.map((json) => AerobicActivity.fromJson(json)).toList();
    } catch (e) {
      // Error loading aerobic data
    }
  }

  AerobicActivity? findActivity(String variant) {
    try {
      return _activities.firstWhere((a) => a.variant == variant);
    } catch (e) {
      return null;
    }
  }

  double calculateCalories({
    required AerobicActivity activity,
    required double weightKg,
    required double units, 
  }) {
    // units is e.g. "number of 10000 steps" or "number of hours"
    return activity.caloriesPerKgPerUnit * weightKg * units;
  }
}
