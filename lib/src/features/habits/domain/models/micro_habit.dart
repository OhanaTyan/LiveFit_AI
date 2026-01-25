

// 微习惯类型
enum MicroHabitType {
  fitness,      // 健身类
  wellness,     // 健康类
  productivity, // 生产力类
  nutrition,    // 营养类
  mindfulness,  // 正念类
  sleep,        // 睡眠类
}

// 微习惯难度
enum MicroHabitDifficulty {
  easy,      // 简单
  medium,    // 中等
  challenging, // 有挑战
}

// 微习惯模型
class MicroHabit {
  final String id;
  final String title;
  final String description;
  final MicroHabitType type;
  final MicroHabitDifficulty difficulty;
  final int durationMinutes; // 预计完成时间（分钟）
  final bool isActive; // 是否活跃
  final DateTime createdAt;
  final DateTime? lastCompletedAt;
  final int streak; // 当前连续完成天数
  final double completionRate; // 完成率（0-1）
  final String? reminderTime; // 提醒时间（HH:mm格式）
  final List<DateTime> completionHistory; // 完成历史

  MicroHabit({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.durationMinutes,
    this.isActive = true,
    required this.createdAt,
    this.lastCompletedAt,
    this.streak = 0,
    this.completionRate = 0.0,
    this.reminderTime,
    this.completionHistory = const [],
  });

  // 创建微习惯的工厂方法
  factory MicroHabit.create({
    required String title,
    required String description,
    required MicroHabitType type,
    required MicroHabitDifficulty difficulty,
    required int durationMinutes,
    String? reminderTime,
  }) {
    return MicroHabit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      difficulty: difficulty,
      durationMinutes: durationMinutes,
      createdAt: DateTime.now(),
      reminderTime: reminderTime,
    );
  }

  // 标记微习惯为已完成
  MicroHabit markAsCompleted() {
    final now = DateTime.now();
    final updatedHistory = [...completionHistory, now];
    
    // 计算新的连续完成天数
    int updatedStreak = streak;
    if (lastCompletedAt != null) {
      final daysDiff = now.difference(lastCompletedAt!).inDays;
      if (daysDiff == 1) {
        updatedStreak += 1;
      } else if (daysDiff > 1) {
        updatedStreak = 1;
      }
    } else {
      updatedStreak = 1;
    }
    
    // 计算完成率（过去7天的完成情况）
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentCompletions = updatedHistory.where((date) => date.isAfter(sevenDaysAgo)).length;
    final updatedCompletionRate = recentCompletions / 7.0;
    
    return copyWith(
      lastCompletedAt: now,
      streak: updatedStreak,
      completionRate: updatedCompletionRate,
      completionHistory: updatedHistory,
    );
  }

  // 复制并更新微习惯
  MicroHabit copyWith({
    String? id,
    String? title,
    String? description,
    MicroHabitType? type,
    MicroHabitDifficulty? difficulty,
    int? durationMinutes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
    int? streak,
    double? completionRate,
    String? reminderTime,
    List<DateTime>? completionHistory,
  }) {
    return MicroHabit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      streak: streak ?? this.streak,
      completionRate: completionRate ?? this.completionRate,
      reminderTime: reminderTime ?? this.reminderTime,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }

  // 将微习惯转换为Map（用于存储）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'durationMinutes': durationMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'streak': streak,
      'completionRate': completionRate,
      'reminderTime': reminderTime,
      'completionHistory': completionHistory.map((date) => date.toIso8601String()).toList(),
    };
  }

  // 从Map创建微习惯
  factory MicroHabit.fromMap(Map<String, dynamic> map) {
    return MicroHabit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: MicroHabitType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      difficulty: MicroHabitDifficulty.values.firstWhere(
        (e) => e.toString().split('.').last == map['difficulty'],
      ),
      durationMinutes: map['durationMinutes'],
      isActive: map['isActive'],
      createdAt: DateTime.parse(map['createdAt']),
      lastCompletedAt: map['lastCompletedAt'] != null
          ? DateTime.parse(map['lastCompletedAt'])
          : null,
      streak: map['streak'],
      completionRate: map['completionRate'],
      reminderTime: map['reminderTime'],
      completionHistory: (map['completionHistory'] as List<dynamic>)
          .map((dateStr) => DateTime.parse(dateStr as String))
          .toList(),
    );
  }
}

// 微习惯建议模型
class MicroHabitSuggestion {
  final String id;
  final String title;
  final String description;
  final MicroHabitType type;
  final MicroHabitDifficulty difficulty;
  final int durationMinutes;
  final String reason; // 推荐理由
  final double relevanceScore; // 相关性评分（0-1）

  MicroHabitSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.durationMinutes,
    required this.reason,
    required this.relevanceScore,
  });
}
