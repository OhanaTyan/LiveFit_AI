enum ExerciseSuitability {
  verySuitable,
  suitable,
  moderatelySuitable,
  unsuitable
}

class ExerciseRecommendation {
  final ExerciseSuitability suitability;
  final String recommendationKey;
  final List<String> suitableExercises;
  final List<String> unsuitableExercises;
  final String weatherAlertKey;
  final bool isOutdoorRecommended;

  ExerciseRecommendation({
    required this.suitability,
    required this.recommendationKey,
    required this.suitableExercises,
    required this.unsuitableExercises,
    required this.weatherAlertKey,
    required this.isOutdoorRecommended,
  });

  Map<String, dynamic> toMap() {
    return {
      'suitability': suitability.index,
      'recommendationKey': recommendationKey,
      'suitableExercises': suitableExercises,
      'unsuitableExercises': unsuitableExercises,
      'weatherAlertKey': weatherAlertKey,
      'isOutdoorRecommended': isOutdoorRecommended,
    };
  }

  factory ExerciseRecommendation.fromMap(Map<String, dynamic> map) {
    return ExerciseRecommendation(
      suitability: ExerciseSuitability.values[map['suitability']],
      recommendationKey: map['recommendationKey'],
      suitableExercises: List<String>.from(map['suitableExercises']),
      unsuitableExercises: List<String>.from(map['unsuitableExercises']),
      weatherAlertKey: map['weatherAlertKey'],
      isOutdoorRecommended: map['isOutdoorRecommended'],
    );
  }
}
