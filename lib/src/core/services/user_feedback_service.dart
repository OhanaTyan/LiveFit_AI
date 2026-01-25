import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 反馈类型
enum FeedbackType {
  accept,
  reject,
  modify,
  ignore,
}

// 反馈模型
class Feedback {
  final String id;
  final String suggestionId;
  final String suggestionTitle;
  final FeedbackType type;
  final DateTime timestamp;
  final String? notes;
  final Map<String, dynamic>? metadata;
  
  Feedback({
    required this.id,
    required this.suggestionId,
    required this.suggestionTitle,
    required this.type,
    required this.timestamp,
    this.notes,
    this.metadata,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'suggestionId': suggestionId,
      'suggestionTitle': suggestionTitle,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }
  
  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] as String,
      suggestionId: json['suggestionId'] as String,
      suggestionTitle: json['suggestionTitle'] as String,
      type: FeedbackType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => FeedbackType.ignore,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

class UserFeedbackService {
  static UserFeedbackService? _instance;
  static late SharedPreferences _prefs;
  
  // Storage keys
  static const String kUserFeedback = 'user_feedback';
  static const String kUserPreferences = 'user_preferences';
  static const String kActivityPatterns = 'activity_patterns';
  
  factory UserFeedbackService() {
    _instance ??= UserFeedbackService._internal();
    return _instance!;
  }
  
  UserFeedbackService._internal();
  
  // 初始化
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // 保存反馈
  Future<bool> saveFeedback(Feedback feedback) async {
    try {
      final feedbacks = await loadFeedbacks();
      feedbacks.add(feedback);
      
      final jsonList = feedbacks.map((f) => f.toJson()).toList();
      final json = jsonEncode(jsonList);
      await _prefs.setString(kUserFeedback, json);
      
      // 分析反馈并更新用户偏好
      _updateUserPreferences(feedbacks);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // 加载所有反馈
  Future<List<Feedback>> loadFeedbacks() async {
    try {
      final jsonString = _prefs.getString(kUserFeedback);
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList.map((item) => Feedback.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // 处理错误
    }
    return [];
  }
  
  // 更新用户偏好
  void _updateUserPreferences(List<Feedback> feedbacks) {
    try {
      // 分析反馈数据
      final preferences = <String, dynamic>{
        'preferredSuggestions': <String, int>{},
        'dislikedSuggestions': <String, int>{},
        'feedbackCount': feedbacks.length,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      // 统计建议的接受和拒绝次数
      for (final feedback in feedbacks) {
        if (feedback.type == FeedbackType.accept) {
          final count = (preferences['preferredSuggestions'] as Map<String, int>)[feedback.suggestionTitle] ?? 0;
          (preferences['preferredSuggestions'] as Map<String, int>)[feedback.suggestionTitle] = count + 1;
        } else if (feedback.type == FeedbackType.reject) {
          final count = (preferences['dislikedSuggestions'] as Map<String, int>)[feedback.suggestionTitle] ?? 0;
          (preferences['dislikedSuggestions'] as Map<String, int>)[feedback.suggestionTitle] = count + 1;
        }
      }
      
      // 保存用户偏好
      final json = jsonEncode(preferences);
      _prefs.setString(kUserPreferences, json);
    } catch (e) {
      // 处理错误
    }
  }
  
  // 加载用户偏好
  Future<Map<String, dynamic>> loadUserPreferences() async {
    try {
      final jsonString = _prefs.getString(kUserPreferences);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      // 处理错误
    }
    return {
      'preferredSuggestions': <String, int>{},
      'dislikedSuggestions': <String, int>{},
      'feedbackCount': 0,
    };
  }
  
  // 分析用户活动模式
  Future<Map<String, dynamic>> analyzeActivityPatterns(List<Map<String, dynamic>> activities) async {
    try {
      final patterns = <String, dynamic>{
        'timeDistribution': <int, int>{},
        'activityTypes': <String, int>{},
        'durationPatterns': <String, int>{},
        'weeklyPatterns': <int, int>{}, // 0-6 表示周日到周六
      };
      
      // 初始化时间分布
      for (int hour = 0; hour < 24; hour++) {
        patterns['timeDistribution'][hour] = 0;
      }
      
      // 初始化周模式
      for (int day = 0; day < 7; day++) {
        patterns['weeklyPatterns'][day] = 0;
      }
      
      // 分析活动数据
      for (final activity in activities) {
        final startTime = DateTime.parse(activity['startTime'] as String);
        final hour = startTime.hour;
        final dayOfWeek = startTime.weekday % 7; // 0-6 表示周日到周六
        final activityType = activity['type'] as String? ?? 'unknown';
        final duration = activity['durationMinutes'] as int? ?? 0;
        
        // 更新时间分布
        patterns['timeDistribution'][hour] = (patterns['timeDistribution'][hour] as int) + 1;
        
        // 更新周模式
        patterns['weeklyPatterns'][dayOfWeek] = (patterns['weeklyPatterns'][dayOfWeek] as int) + 1;
        
        // 更新活动类型分布
        final typeCount = (patterns['activityTypes'] as Map<String, int>)[activityType] ?? 0;
        (patterns['activityTypes'] as Map<String, int>)[activityType] = typeCount + 1;
        
        // 更新持续时间模式
        final durationRange = _getDurationRange(duration);
        final durationCount = (patterns['durationPatterns'] as Map<String, int>)[durationRange] ?? 0;
        (patterns['durationPatterns'] as Map<String, int>)[durationRange] = durationCount + 1;
      }
      
      // 保存活动模式
      final json = jsonEncode(patterns);
      await _prefs.setString(kActivityPatterns, json);
      
      return patterns;
    } catch (e) {
      return {
        'timeDistribution': <int, int>{},
        'activityTypes': <String, int>{},
        'durationPatterns': <String, int>{},
        'weeklyPatterns': <int, int>{},
      };
    }
  }
  
  // 获取持续时间范围
  String _getDurationRange(int duration) {
    if (duration < 5) return '0-5min';
    if (duration < 15) return '5-15min';
    if (duration < 30) return '15-30min';
    if (duration < 60) return '30-60min';
    return '60+min';
  }
  
  // 加载活动模式
  Future<Map<String, dynamic>> loadActivityPatterns() async {
    try {
      final jsonString = _prefs.getString(kActivityPatterns);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      // 处理错误
    }
    return {
      'timeDistribution': <int, int>{},
      'activityTypes': <String, int>{},
      'durationPatterns': <String, int>{},
      'weeklyPatterns': <int, int>{},
    };
  }
  
  // 基于反馈生成建议优化
  Future<Map<String, dynamic>> generateSuggestionOptimizations() async {
    try {
      final preferences = await loadUserPreferences();
      final patterns = await loadActivityPatterns();
      
      // 分析反馈趋势
      final optimizations = <String, dynamic>{
        'preferredSuggestions': <String, double>{},
        'avoidSuggestions': <String, double>{},
        'optimalTimes': <int, double>{},
        'preferredDurations': <String, double>{},
      };
      
      // 计算建议的偏好分数
      final preferred = preferences['preferredSuggestions'] as Map<String, int>;
      final disliked = preferences['dislikedSuggestions'] as Map<String, int>;
      
      for (final entry in preferred.entries) {
        final score = entry.value.toDouble();
        optimizations['preferredSuggestions'][entry.key] = score;
      }
      
      for (final entry in disliked.entries) {
        final score = entry.value.toDouble();
        optimizations['avoidSuggestions'][entry.key] = score;
      }
      
      // 分析最佳活动时间
      final timeDistribution = patterns['timeDistribution'] as Map<String, dynamic>;
      for (final entry in timeDistribution.entries) {
        final hour = int.parse(entry.key);
        final count = (entry.value as int).toDouble();
        optimizations['optimalTimes'][hour] = count;
      }
      
      // 分析偏好的活动 duration
      final durationPatterns = patterns['durationPatterns'] as Map<String, dynamic>;
      for (final entry in durationPatterns.entries) {
        final duration = entry.key;
        final count = (entry.value as int).toDouble();
        optimizations['preferredDurations'][duration] = count;
      }
      
      return optimizations;
    } catch (e) {
      return {
        'preferredSuggestions': <String, double>{},
        'avoidSuggestions': <String, double>{},
        'optimalTimes': <int, double>{},
        'preferredDurations': <String, double>{},
      };
    }
  }
  
  // 清除所有数据
  Future<void> clearAll() async {
    try {
      await _prefs.remove(kUserFeedback);
      await _prefs.remove(kUserPreferences);
      await _prefs.remove(kActivityPatterns);
    } catch (e) {
      // 处理错误
    }
  }
}
