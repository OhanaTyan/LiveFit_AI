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
