import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../onboarding/domain/onboarding_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/user_profile_provider.dart';
import '../../domain/user_profile.dart';

// Icon mapping for aerobic exercises
const Map<AerobicExerciseType, IconData> aerobicExerciseIcons = {
  // Running
  AerobicExerciseType.running: Icons.directions_run,
  AerobicExerciseType.jogging: Icons.run_circle,
  AerobicExerciseType.walking: Icons.directions_walk,
  
  // Cycling
  AerobicExerciseType.cycling: Icons.directions_bike,
  AerobicExerciseType.stationaryBike: Icons.pedal_bike,
  
  // Swimming
  AerobicExerciseType.swimming: Icons.pool,
  
  //球类
  AerobicExerciseType.basketball: Icons.sports_basketball,
  AerobicExerciseType.football: Icons.sports_soccer,
  AerobicExerciseType.tennis: Icons.sports_tennis,
  AerobicExerciseType.badminton: Icons.sports_tennis,
  AerobicExerciseType.volleyball: Icons.sports_volleyball,
  
  // 其他
  AerobicExerciseType.aerobics: Icons.fitness_center,
  AerobicExerciseType.dancing: Icons.directions_walk,
  AerobicExerciseType.jumpingRope: Icons.fitness_center,
  AerobicExerciseType.hiking: Icons.hiking,
  
  // 水上运动
  AerobicExerciseType.waterAerobics: Icons.pool,
  
  // 冬季运动
  AerobicExerciseType.skiing: Icons.downhill_skiing,
  AerobicExerciseType.skating: Icons.skateboarding,
};

class AerobicHabitsEditPage extends StatefulWidget {
  static const routeName = '/profile/aerobic-habits-edit';

  const AerobicHabitsEditPage({super.key});

  @override
  State<AerobicHabitsEditPage> createState() => _AerobicHabitsEditPageState();
}

class _AerobicHabitsEditPageState extends State<AerobicHabitsEditPage> {
  late OnboardingState _state;
  late UserProfileProvider _userProfileProvider;

  @override
  void initState() {
    super.initState();
    // Get the UserProfileProvider and initialize state from user profile
    _userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    _state = _createOnboardingStateFromUserProfile(_userProfileProvider.userProfile);
  }

  OnboardingState _createOnboardingStateFromUserProfile(UserProfile userProfile) {
    // Create a new OnboardingState with data from UserProfile
    final state = OnboardingState();
    
    // Add aerobic exercises from user profile
    for (final exercise in userProfile.aerobicExercises) {
      state.toggleAerobicExercise(exercise);
      
      // Set default time based on weekly exercise time enum
      int defaultTime = 30; // Default value
      switch (userProfile.weeklyExerciseTime) {
        case WeeklyExerciseTime.lessThan30Minutes:
          defaultTime = 15;
          break;
        case WeeklyExerciseTime.thirtyMinutes:
          defaultTime = 30;
          break;
        case WeeklyExerciseTime.oneHour:
          defaultTime = 60;
          break;
        case WeeklyExerciseTime.oneAndHalfHours:
          defaultTime = 90;
          break;
        case WeeklyExerciseTime.twoHours:
          defaultTime = 120;
          break;
        case WeeklyExerciseTime.moreThanTwoHours:
          defaultTime = 150;
          break;
      }
      state.setAerobicExerciseTime(exercise, defaultTime);
    }
    
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aerobicHabitsTitle),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.aerobicHabitsSectionTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.aerobicHabitsDescription,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),

            // Running
            Text(
              AppLocalizations.of(context)!.aerobicCategoryRunning,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAerobicChip(AerobicExerciseType.running, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Running'), aerobicExerciseIcons[AerobicExerciseType.running]!),
                _buildAerobicChip(AerobicExerciseType.jogging, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Jogging'), aerobicExerciseIcons[AerobicExerciseType.jogging]!),
                _buildAerobicChip(AerobicExerciseType.walking, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Walking'), aerobicExerciseIcons[AerobicExerciseType.walking]!),
              ],
            ),

            const SizedBox(height: 24),

            // Cycling
            Text(
              AppLocalizations.of(context)!.aerobicCategoryCycling,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAerobicChip(AerobicExerciseType.cycling, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Cycling'), aerobicExerciseIcons[AerobicExerciseType.cycling]!),
                _buildAerobicChip(AerobicExerciseType.stationaryBike, AppLocalizations.of(context)!.getAerobicExerciseTypeName('StationaryBike'), aerobicExerciseIcons[AerobicExerciseType.stationaryBike]!),
              ],
            ),

            const SizedBox(height: 24),

            // Swimming
            Text(
              AppLocalizations.of(context)!.aerobicCategorySwimming,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAerobicChip(AerobicExerciseType.swimming, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Swimming'), aerobicExerciseIcons[AerobicExerciseType.swimming]!),
                _buildAerobicChip(AerobicExerciseType.waterAerobics, AppLocalizations.of(context)!.getAerobicExerciseTypeName('WaterAerobics'), aerobicExerciseIcons[AerobicExerciseType.waterAerobics]!),
              ],
            ),

            const SizedBox(height: 24),

            // Ball Sports
            Text(
              AppLocalizations.of(context)!.aerobicCategoryBallSports,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAerobicChip(AerobicExerciseType.basketball, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Basketball'), aerobicExerciseIcons[AerobicExerciseType.basketball]!),
                _buildAerobicChip(AerobicExerciseType.football, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Football'), aerobicExerciseIcons[AerobicExerciseType.football]!),
                _buildAerobicChip(AerobicExerciseType.tennis, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Tennis'), aerobicExerciseIcons[AerobicExerciseType.tennis]!),
                _buildAerobicChip(AerobicExerciseType.badminton, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Badminton'), aerobicExerciseIcons[AerobicExerciseType.badminton]!),
                _buildAerobicChip(AerobicExerciseType.volleyball, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Volleyball'), aerobicExerciseIcons[AerobicExerciseType.volleyball]!),
              ],
            ),

            const SizedBox(height: 24),

            // Other
            Text(
              AppLocalizations.of(context)!.aerobicCategoryOther,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAerobicChip(AerobicExerciseType.aerobics, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Aerobics'), aerobicExerciseIcons[AerobicExerciseType.aerobics]!),
                _buildAerobicChip(AerobicExerciseType.dancing, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Dancing'), aerobicExerciseIcons[AerobicExerciseType.dancing]!),
                _buildAerobicChip(AerobicExerciseType.jumpingRope, AppLocalizations.of(context)!.getAerobicExerciseTypeName('JumpingRope'), aerobicExerciseIcons[AerobicExerciseType.jumpingRope]!),
                _buildAerobicChip(AerobicExerciseType.hiking, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Hiking'), aerobicExerciseIcons[AerobicExerciseType.hiking]!),
                _buildAerobicChip(AerobicExerciseType.skiing, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Skiing'), aerobicExerciseIcons[AerobicExerciseType.skiing]!),
                _buildAerobicChip(AerobicExerciseType.skating, AppLocalizations.of(context)!.getAerobicExerciseTypeName('Skating'), aerobicExerciseIcons[AerobicExerciseType.skating]!),
              ],
            ),

            const SizedBox(height: 48),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Save the aerobic exercise habits
                  _saveAerobicHabits();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                ),
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _saveAerobicHabits() {
    // Calculate total weekly exercise time from aerobicExerciseTimes
    int totalMinutes = 0;
    for (final minutes in _state.aerobicExerciseTimes.values) {
      totalMinutes += minutes;
    }
    
    // Map total minutes to WeeklyExerciseTime enum
    WeeklyExerciseTime weeklyTime;
    if (totalMinutes < 30) {
      weeklyTime = WeeklyExerciseTime.lessThan30Minutes;
    } else if (totalMinutes == 30) {
      weeklyTime = WeeklyExerciseTime.thirtyMinutes;
    } else if (totalMinutes < 60) {
      weeklyTime = WeeklyExerciseTime.thirtyMinutes;
    } else if (totalMinutes == 60) {
      weeklyTime = WeeklyExerciseTime.oneHour;
    } else if (totalMinutes < 90) {
      weeklyTime = WeeklyExerciseTime.oneHour;
    } else if (totalMinutes == 90) {
      weeklyTime = WeeklyExerciseTime.oneAndHalfHours;
    } else if (totalMinutes < 120) {
      weeklyTime = WeeklyExerciseTime.oneAndHalfHours;
    } else if (totalMinutes == 120) {
      weeklyTime = WeeklyExerciseTime.twoHours;
    } else {
      weeklyTime = WeeklyExerciseTime.moreThanTwoHours;
    }
    
    // Calculate age for BMR calculation
    final now = DateTime.now();
    int age = now.year - _userProfileProvider.userProfile.birthday.year;
    if (now.month < _userProfileProvider.userProfile.birthday.month || 
        (now.month == _userProfileProvider.userProfile.birthday.month && now.day < _userProfileProvider.userProfile.birthday.day)) {
      age--;
    }
    
    // Mifflin-St Jeor formula for BMR
    double s = _userProfileProvider.userProfile.gender == Gender.male ? 5 : -161;
    double bmr = (10 * _userProfileProvider.userProfile.weight) + (6.25 * _userProfileProvider.userProfile.height) - (5 * age) + s;
    
    // Calculate other calorie values
    double noExerciseTotalConsumption = bmr / 0.7;
    
    // Strength training consumption based on experience level and gender
    double strengthTrainingConsumption;
    switch (_userProfileProvider.userProfile.experienceLevel) {
      case ExperienceLevel.beginner:
        strengthTrainingConsumption = _userProfileProvider.userProfile.gender == Gender.male ? 150 : 100;
        break;
      case ExperienceLevel.intermediate:
        strengthTrainingConsumption = _userProfileProvider.userProfile.gender == Gender.male ? 200 : 150;
        break;
      case ExperienceLevel.advanced:
        strengthTrainingConsumption = _userProfileProvider.userProfile.gender == Gender.male ? 250 : 200;
        break;
    }
    
    // Calculate aerobic consumption based on selected exercises and their times
    double weeklyAerobicCalories = 0;
    for (final exerciseType in _state.aerobicExercises) {
      final exercise = aerobicExercisesData[exerciseType];
      final minutes = _state.aerobicExerciseTimes[exerciseType];
      
      if (exercise != null && minutes != null && minutes > 0) {
        // Calories burned formula: weight (kg) * MET * time (minutes) * 3.5 / 200
        double calories = (_userProfileProvider.userProfile.weight * exercise.met * minutes * 3.5) / 200;
        
        // Apply weight adjustment: from 80kg, every 5kg increase decreases calorie burn by 3%
        if (_userProfileProvider.userProfile.weight >= 80) {
          int weightAbove80 = (_userProfileProvider.userProfile.weight - 80).round();
          int decrementSteps = weightAbove80 ~/ 5;
          double weightAdjustment = 1.0 - (decrementSteps * 0.03);
          calories *= weightAdjustment;
        }
        
        weeklyAerobicCalories += calories;
      }
    }
    
    double aerobicConsumption = weeklyAerobicCalories / 7;
    
    // Calculate balance calories
    double strengthTrainingDayBalance = noExerciseTotalConsumption + strengthTrainingConsumption + aerobicConsumption;
    double restDayBalance = noExerciseTotalConsumption + aerobicConsumption;
    
    // Calculate recommended calories
    double strengthTrainingDayShouldEat = strengthTrainingDayBalance * 0.64;
    double restDayShouldEat = restDayBalance * 0.64;
    
    // Update user profile with new aerobic habits and calorie data
    final mergedProfile = _userProfileProvider.userProfile.copyWith(
      aerobicExercises: _state.aerobicExercises,
      weeklyExerciseTime: weeklyTime,
      // Update calorie data
      basalMetabolism: bmr,
      noExerciseTotalConsumption: noExerciseTotalConsumption,
      strengthTrainingConsumption: strengthTrainingConsumption,
      aerobicConsumption: aerobicConsumption,
      strengthTrainingDayBalance: strengthTrainingDayBalance,
      restDayBalance: restDayBalance,
      strengthTrainingDayShouldEat: strengthTrainingDayShouldEat,
      restDayShouldEat: restDayShouldEat,
    );
    
    // Save to provider
    _userProfileProvider.updateUserProfile(mergedProfile);
    
    // Navigate back
    Navigator.pop(context);
  }

  Widget _buildAerobicChip(AerobicExerciseType exercise, String label, IconData icon) {
    final isSelected = _state.aerobicExercises.contains(exercise);
    final exerciseTime = isSelected ? _state.aerobicExerciseTimes[exercise] ?? 30 : 30;
    final isStationaryBike = exercise == AerobicExerciseType.stationaryBike;
    
    // Check if current language is English
    final isEnglish = AppLocalizations.of(context)?.locale.languageCode == 'en';
    
    // For English mode or stationary bike, use column layout to avoid overflow
    if (isEnglish || (isStationaryBike && isSelected)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterChip(
            label: Text(label),
            avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
            selected: isSelected,
            onSelected: (_) => setState(() => _state.toggleAerobicExercise(exercise)),
            backgroundColor: AppColors.surfaceLight,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.surfaceLight : AppColors.textPrimaryLight,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            checkmarkColor: AppColors.surfaceLight,
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.borderLight, width: 1),
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.aerobicWeeklyTime, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                  IconButton(
                    onPressed: () => setState(() => _state.setAerobicExerciseTime(exercise, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15)),
                    icon: const Icon(Icons.remove_circle, size: 18),
                    color: AppColors.primary,
                  ),
                  Text('$exerciseTime ${AppLocalizations.of(context)!.minutes}', style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryLight)),
                  IconButton(
                    onPressed: () => setState(() => _state.setAerobicExerciseTime(exercise, exerciseTime + 15)),
                    icon: const Icon(Icons.add_circle, size: 18),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      );
    }
    
    // For other languages, use row layout
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilterChip(
          label: Text(label),
          avatar: Icon(icon, size: 16, color: isSelected ? AppColors.surfaceLight : AppColors.textSecondaryLight),
          selected: isSelected,
          onSelected: (_) => setState(() => _state.toggleAerobicExercise(exercise)),
          backgroundColor: AppColors.surfaceLight,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.surfaceLight : AppColors.textPrimaryLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          checkmarkColor: AppColors.surfaceLight,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.borderLight, width: 1),
          ),
        ),
        if (isSelected)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(AppLocalizations.of(context)!.aerobicWeeklyTime, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                IconButton(
                  onPressed: () => setState(() => _state.setAerobicExerciseTime(exercise, exerciseTime - 15 >= 15 ? exerciseTime - 15 : 15)),
                  icon: const Icon(Icons.remove_circle, size: 18),
                  color: AppColors.primary,
                ),
                Text('$exerciseTime ${AppLocalizations.of(context)!.minutes}', style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryLight)),
                IconButton(
                  onPressed: () => setState(() => _state.setAerobicExerciseTime(exercise, exerciseTime + 15)),
                  icon: const Icon(Icons.add_circle, size: 18),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
