import 'dart:math';
import '../../../../core/services/schedule_analysis_service.dart';
import '../../../schedule/domain/models/schedule_event.dart';
import '../models/micro_habit.dart';

class MicroHabitGeneratorService {
  static MicroHabitGeneratorService? _instance;
  
  factory MicroHabitGeneratorService() {
    _instance ??= MicroHabitGeneratorService._internal();
    return _instance!;
  }
  
  MicroHabitGeneratorService._internal();
  
  // 预定义的微习惯模板库
  final List<Map<String, dynamic>> _habitTemplates = [
    // 健身类
    {
      'title': '晨练5分钟',
      'description': '每天早上进行5分钟的伸展运动，唤醒身体',
      'type': MicroHabitType.fitness,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 5,
      'keywords': ['晨练', '伸展', '唤醒'],
    },
    {
      'title': '午间步行',
      'description': '午餐后进行10分钟的步行，促进消化',
      'type': MicroHabitType.fitness,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 10,
      'keywords': ['步行', '消化', '午间'],
    },
    {
      'title': '睡前放松',
      'description': '睡前进行5分钟的深呼吸练习，帮助入睡',
      'type': MicroHabitType.mindfulness,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 5,
      'keywords': ['放松', '呼吸', '睡眠'],
    },
    {
      'title': '多喝水',
      'description': '每小时喝一杯水，保持身体水分',
      'type': MicroHabitType.nutrition,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 2,
      'keywords': ['喝水', '水分', '健康'],
    },
    {
      'title': '专注工作25分钟',
      'description': '进行25分钟的专注工作，然后休息5分钟',
      'type': MicroHabitType.productivity,
      'difficulty': MicroHabitDifficulty.medium,
      'durationMinutes': 25,
      'keywords': ['专注', '工作', '效率'],
    },
    {
      'title': '阅读10分钟',
      'description': '每天阅读10分钟，拓展知识面',
      'type': MicroHabitType.productivity,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 10,
      'keywords': ['阅读', '学习', '知识'],
    },
    {
      'title': '冥想5分钟',
      'description': '每天进行5分钟的冥想，提高专注力',
      'type': MicroHabitType.mindfulness,
      'difficulty': MicroHabitDifficulty.medium,
      'durationMinutes': 5,
      'keywords': ['冥想', '专注', '正念'],
    },
    {
      'title': '做30个深蹲',
      'description': '每天做30个深蹲，锻炼下肢力量',
      'type': MicroHabitType.fitness,
      'difficulty': MicroHabitDifficulty.medium,
      'durationMinutes': 5,
      'keywords': ['深蹲', '力量', '下肢'],
    },
    {
      'title': '记录饮食',
      'description': '每天记录一次饮食，了解自己的饮食习惯',
      'type': MicroHabitType.nutrition,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 5,
      'keywords': ['饮食', '记录', '健康'],
    },
    {
      'title': '整理桌面',
      'description': '每天结束工作前整理桌面，保持整洁',
      'type': MicroHabitType.productivity,
      'difficulty': MicroHabitDifficulty.easy,
      'durationMinutes': 5,
      'keywords': ['整理', '整洁', '效率'],
    },
  ];
  
  // 根据用户日程生成个性化微习惯建议
  List<MicroHabitSuggestion> generatePersonalizedHabitSuggestions(
    List<ScheduleEvent> events,
    {int count = 3}
  ) {
    final suggestions = <MicroHabitSuggestion>[];
    final rng = Random();
    
    // 分析用户日程
    final scheduleAnalysis = ScheduleAnalysisService();
    final gaps = scheduleAnalysis.identifyTimeGaps(events);
    final userPatterns = scheduleAnalysis.analyzeUserPatterns(events);
    final density = scheduleAnalysis.analyzeScheduleDensity(events);
    
    // 基于日程密度选择合适的微习惯难度
    final difficulty = _selectDifficultyBasedOnScheduleDensity(density['densityLevel'] as String);
    
    // 基于用户活动模式选择合适的微习惯类型
    final preferredTypes = _selectPreferredHabitTypes(userPatterns);
    
    // 筛选适合的微习惯模板
    final suitableTemplates = _habitTemplates.where((template) {
      return preferredTypes.contains(template['type']) &&
             template['difficulty'] == difficulty &&
             _isTemplateSuitableForSchedule(template, gaps);
    }).toList();
    
    // 如果没有找到合适的模板，放宽难度限制
    if (suitableTemplates.isEmpty) {
      final allSuitableTemplates = _habitTemplates.where((template) {
        return preferredTypes.contains(template['type']) &&
               _isTemplateSuitableForSchedule(template, gaps);
      }).toList();
      
      if (allSuitableTemplates.isNotEmpty) {
        // 随机选择一些模板
        allSuitableTemplates.shuffle(rng);
        final selectedTemplates = allSuitableTemplates.take(min(count, allSuitableTemplates.length)).toList();
        
        for (final template in selectedTemplates) {
          suggestions.add(_createHabitSuggestion(template, events, userPatterns));
        }
      }
    } else {
      // 从合适的模板中选择
      suitableTemplates.shuffle(rng);
      final selectedTemplates = suitableTemplates.take(min(count, suitableTemplates.length)).toList();
      
      for (final template in selectedTemplates) {
        suggestions.add(_createHabitSuggestion(template, events, userPatterns));
      }
    }
    
    // 如果建议数量不足，生成额外的建议
    if (suggestions.length < count) {
      final remainingCount = count - suggestions.length;
      for (int i = 0; i < remainingCount; i++) {
        final randomTemplate = _habitTemplates[rng.nextInt(_habitTemplates.length)];
        suggestions.add(_createHabitSuggestion(randomTemplate, events, userPatterns));
      }
    }
    
    // 按相关性评分排序
    suggestions.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    return suggestions;
  }
  
  // 根据日程密度选择合适的微习惯难度
  MicroHabitDifficulty _selectDifficultyBasedOnScheduleDensity(String densityLevel) {
    switch (densityLevel) {
      case 'extreme':
      case 'heavy':
        return MicroHabitDifficulty.easy;
      case 'medium':
        return MicroHabitDifficulty.medium;
      case 'light':
      case 'very_light':
        return MicroHabitDifficulty.challenging;
      default:
        return MicroHabitDifficulty.easy;
    }
  }
  
  // 基于用户活动模式选择合适的微习惯类型
  List<MicroHabitType> _selectPreferredHabitTypes(Map<String, dynamic> userPatterns) {
    final preferredTypes = <MicroHabitType>[];
    
    // 分析用户活动平衡
    final activityBalance = userPatterns['activityBalance'] as String?;
    
    if (activityBalance == 'work_heavy') {
      // 工作繁重，推荐健康和放松类微习惯
      preferredTypes.addAll([
        MicroHabitType.wellness,
        MicroHabitType.mindfulness,
        MicroHabitType.fitness,
      ]);
    } else if (activityBalance == 'active_but_no_rest') {
      // 活动丰富但缺乏休息，推荐休息和正念类微习惯
      preferredTypes.addAll([
        MicroHabitType.sleep,
        MicroHabitType.mindfulness,
        MicroHabitType.wellness,
      ]);
    } else if (activityBalance == 'sedentary') {
      // 久坐不动，推荐健身和活动类微习惯
      preferredTypes.addAll([
        MicroHabitType.fitness,
        MicroHabitType.wellness,
        MicroHabitType.nutrition,
      ]);
    } else {
      // 平衡状态，推荐各类微习惯
      preferredTypes.addAll([
        MicroHabitType.fitness,
        MicroHabitType.productivity,
        MicroHabitType.mindfulness,
        MicroHabitType.nutrition,
      ]);
    }
    
    return preferredTypes;
  }
  
  // 检查模板是否适合用户日程
  bool _isTemplateSuitableForSchedule(
    Map<String, dynamic> template,
    List<dynamic> gaps,
  ) {
    final duration = template['durationMinutes'] as int;
    
    // 检查是否有足够的时间间隙
    return gaps.any((gap) => gap.duration.inMinutes >= duration + 5);
  }
  
  // 创建微习惯建议
  MicroHabitSuggestion _createHabitSuggestion(
    Map<String, dynamic> template,
    List<ScheduleEvent> events,
    Map<String, dynamic> userPatterns,
  ) {
    final rng = Random();
    
    // 计算相关性评分
    final relevanceScore = _calculateRelevanceScore(template, userPatterns);
    
    // 生成推荐理由
    final reason = _generateRecommendationReason(template, userPatterns);
    
    return MicroHabitSuggestion(
      id: 'suggestion_${DateTime.now().millisecondsSinceEpoch}_${rng.nextInt(1000)}',
      title: template['title'] as String,
      description: template['description'] as String,
      type: template['type'] as MicroHabitType,
      difficulty: template['difficulty'] as MicroHabitDifficulty,
      durationMinutes: template['durationMinutes'] as int,
      reason: reason,
      relevanceScore: relevanceScore,
    );
  }
  
  // 计算微习惯与用户的相关性评分
  double _calculateRelevanceScore(
    Map<String, dynamic> template,
    Map<String, dynamic> userPatterns,
  ) {
    double score = 0.5; // 基础分数
    
    // 基于活动平衡调整分数
    final activityBalance = userPatterns['activityBalance'] as String?;
    final type = template['type'] as MicroHabitType;
    
    if (activityBalance == 'work_heavy') {
      if (type == MicroHabitType.wellness || type == MicroHabitType.mindfulness) {
        score += 0.3;
      }
    } else if (activityBalance == 'active_but_no_rest') {
      if (type == MicroHabitType.sleep || type == MicroHabitType.mindfulness) {
        score += 0.3;
      }
    } else if (activityBalance == 'sedentary') {
      if (type == MicroHabitType.fitness) {
        score += 0.3;
      }
    }
    
    // 基于锻炼频率调整分数
    final workoutFrequency = userPatterns['workoutFrequency'] as double? ?? 0;
    if (type == MicroHabitType.fitness) {
      if (workoutFrequency < 0.5) {
        score += 0.2;
      } else if (workoutFrequency > 1.5) {
        score -= 0.1;
      }
    }
    
    // 确保分数在0-1之间
    return min(1.0, max(0.1, score));
  }
  
  // 生成推荐理由
  String _generateRecommendationReason(
    Map<String, dynamic> template,
    Map<String, dynamic> userPatterns,
  ) {
    final type = template['type'] as MicroHabitType;
    final difficulty = template['difficulty'] as MicroHabitDifficulty;
    
    switch (type) {
      case MicroHabitType.fitness:
        return '基于您的日程分析，这个${difficulty.name}级别的健身习惯非常适合您的时间安排，有助于保持身体活力。';
      case MicroHabitType.wellness:
        return '这个${difficulty.name}级别的健康习惯可以帮助您缓解压力，提高整体健康水平。';
      case MicroHabitType.productivity:
        return '这个${difficulty.name}级别的生产力习惯可以帮助您提高工作效率，更好地管理时间。';
      case MicroHabitType.nutrition:
        return '这个${difficulty.name}级别的营养习惯可以帮助您改善饮食习惯，保持健康体重。';
      case MicroHabitType.mindfulness:
        return '这个${difficulty.name}级别的正念习惯可以帮助您提高专注力，减轻焦虑。';
      case MicroHabitType.sleep:
        return '这个${difficulty.name}级别的睡眠习惯可以帮助您改善睡眠质量，提高白天的精力水平。';
    }
  }
  
  // 将微习惯建议转换为可执行的微习惯
  MicroHabit convertSuggestionToHabit(MicroHabitSuggestion suggestion, {String? reminderTime}) {
    return MicroHabit.create(
      title: suggestion.title,
      description: suggestion.description,
      type: suggestion.type,
      difficulty: suggestion.difficulty,
      durationMinutes: suggestion.durationMinutes,
      reminderTime: reminderTime,
    );
  }
  
  // 生成每日微习惯提醒
  List<Map<String, dynamic>> generateDailyHabitReminders(
    List<MicroHabit> habits,
    List<ScheduleEvent> events,
  ) {
    final reminders = <Map<String, dynamic>>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 分析今日日程
    final todayEvents = events.where((event) {
      final eventDate = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      return eventDate.isAtSameMomentAs(today);
    }).toList();
    
    final scheduleAnalysis = ScheduleAnalysisService();
    final todayGaps = scheduleAnalysis.identifyTimeGaps(todayEvents);
    
    // 为每个活跃的微习惯生成提醒
    for (final habit in habits.where((h) => h.isActive)) {
      // 查找合适的提醒时间
      final suitableGaps = todayGaps.where((gap) {
        return gap.duration.inMinutes >= habit.durationMinutes + 5;
      }).toList();
      
      if (suitableGaps.isNotEmpty) {
        // 选择最合适的时间段
        final bestGap = _selectBestGapForHabit(habit, suitableGaps);
        
        reminders.add({
          'habit': habit,
          'suggestedTime': bestGap.start,
          'message': '该完成您的微习惯了：${habit.title}',
        });
      } else if (habit.reminderTime != null) {
        // 使用用户设置的提醒时间
        final reminderParts = habit.reminderTime!.split(':');
        final reminderTime = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(reminderParts[0]),
          int.parse(reminderParts[1]),
        );
        
        reminders.add({
          'habit': habit,
          'suggestedTime': reminderTime,
          'message': '该完成您的微习惯了：${habit.title}',
        });
      }
    }
    
    // 按时间排序
    reminders.sort((a, b) => a['suggestedTime'].compareTo(b['suggestedTime']));
    
    return reminders;
  }
  
  // 为微习惯选择最佳时间间隙
  dynamic _selectBestGapForHabit(MicroHabit habit, List<dynamic> gaps) {
    // 简单实现：选择最早的合适间隙
    gaps.sort((a, b) => a.start.compareTo(b.start));
    return gaps.first;
  }
  
  // 分析用户的微习惯完成情况
  Map<String, dynamic> analyzeHabitCompletion(List<MicroHabit> habits) {
    if (habits.isEmpty) {
      return {
        'totalHabits': 0,
        'activeHabits': 0,
        'completionRate': 0.0,
        'averageStreak': 0,
        'bestStreak': 0,
        'habitTypeDistribution': {},
      };
    }
    
    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletionRate = activeHabits.fold(0.0, (sum, h) => sum + h.completionRate) / activeHabits.length;
    final averageStreak = activeHabits.fold(0, (sum, h) => sum + h.streak) / activeHabits.length;
    final bestStreak = activeHabits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);
    
    // 计算习惯类型分布
    final typeDistribution = <String, int>{};
    for (final habit in habits) {
      final typeName = habit.type.toString().split('.').last;
      typeDistribution[typeName] = (typeDistribution[typeName] ?? 0) + 1;
    }
    
    return {
      'totalHabits': habits.length,
      'activeHabits': activeHabits.length,
      'completionRate': totalCompletionRate,
      'averageStreak': averageStreak,
      'bestStreak': bestStreak,
      'habitTypeDistribution': typeDistribution,
    };
  }
}
