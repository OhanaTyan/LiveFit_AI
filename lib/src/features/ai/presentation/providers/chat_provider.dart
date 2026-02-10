import 'dart:convert';
import '../../../../core/services/event_bus_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/storage_service.dart';
import '../../../profile/presentation/providers/user_profile_provider.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/services/ai_service.dart';
import '../../../schedule/domain/models/schedule_event.dart';
import '../../../../core/theme/app_colors.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _aiService;
  final StorageService _storageService = StorageService();
  UserProfileProvider? _userProfileProvider;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatProvider(this._aiService);

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  // 用于 ProxyProvider 更新依赖
  void updateUserProfileProvider(UserProfileProvider userProfileProvider) {
    _userProfileProvider = userProfileProvider;
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage.user(content);
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      // 构建上下文信息
      final context = await _buildSystemContext();
      
      // 传递历史消息给 Service
      final history = _messages.sublist(0, _messages.length - 1);
      final response = await _aiService.sendMessage(history, content, systemContext: context);
      
      // 解析响应是否包含工具调用
      final toolCall = _parseToolCall(response);
      
      if (toolCall != null) {
        // 如果是工具调用，content 只显示 reason，保留 toolCall 数据
        final aiMessage = ChatMessage.ai(
          toolCall['reason'] ?? '建议更新您的日程',
          toolCall: toolCall,
        );
        _messages.add(aiMessage);
      } else {
        final aiMessage = ChatMessage.ai(response);
        _messages.add(aiMessage);
      }
    } catch (e) {
      final errorMessage = ChatMessage.ai('抱歉，我暂时无法回答。请检查网络或 Token 设置。\n错误详情: $e', isError: true);
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _parseToolCall(String response) {
    try {
      // 查找 json 代码块
      final jsonStart = response.indexOf('```json');
      if (jsonStart == -1) return null;
      
      final jsonEnd = response.indexOf('```', jsonStart + 7);
      if (jsonEnd == -1) return null;
      
      final jsonStr = response.substring(jsonStart + 7, jsonEnd).trim();
      final json = jsonDecode(jsonStr);
      
      if (json is Map<String, dynamic> && json['tool_call'] == 'manage_schedule') {
        return json;
      }
    } catch (e) {
      print('解析工具调用失败: $e');
    }
    return null;
  }

  Future<void> confirmToolCall(ChatMessage message) async {
    if (message.toolCall == null) return;
    
    final toolCall = message.toolCall!;
    final action = toolCall['action'];
    final eventData = toolCall['event'];
    
    try {
      final now = DateTime.now();
      final event = ScheduleEvent(
        id: '${now.millisecondsSinceEpoch}', // 简单生成ID，实际可能需要更复杂逻辑
        title: eventData['title'] ?? '未命名事件',
        description: eventData['description'] ?? '',
        startTime: DateTime.parse(eventData['startTime']),
        endTime: DateTime.parse(eventData['endTime']),
        type: EventType.values.firstWhere(
          (e) => e.name == eventData['type'],
          orElse: () => EventType.life,
        ),
        color: AppColors.primary, // 默认颜色
      );

      // 加载现有事件
      final existingEvents = await _storageService.loadActiveEvents() ?? [];
      
      if (action == 'create') {
        existingEvents.add(event);
      } else if (action == 'update') {
        // 简单实现：先删后加，或者根据ID查找（这里假设是创建新事件来替代）
        // 实际场景可能需要更复杂的ID匹配逻辑，这里简化为添加
        existingEvents.add(event);
      }
      
      await _storageService.saveScheduleEvents(existingEvents);
      
      // 通知更新
      EventBusService().fireEvent(EventBusService.eventScheduleUpdated);
      
      // 添加系统消息确认
      _messages.add(ChatMessage.ai('✅ 已为您${action == 'create' ? '添加' : '更新'}日程：${event.title}'));
      notifyListeners();
      
    } catch (e) {
      _messages.add(ChatMessage.ai('❌ 操作失败: $e', isError: true));
      notifyListeners();
    }
  }
  
  void clearHistory() {
    _messages.clear();
    notifyListeners();
  }

  Future<String> _buildSystemContext() async {
    final buffer = StringBuffer();

    // 1. 用户个人信息
    if (_userProfileProvider != null) {
      final profile = _userProfileProvider!.userProfile;
      buffer.writeln('【用户个人档案】');
      buffer.writeln('昵称: ${profile.nickname}');
      buffer.writeln('性别: ${profile.gender}');
      buffer.writeln('年龄: ${_calculateAge(profile.birthday)}岁');
      buffer.writeln('身高: ${profile.height}cm');
      buffer.writeln('体重: ${profile.weight}kg');
      buffer.writeln('BMI: ${profile.bmi.toStringAsFixed(1)}');
      buffer.writeln('主要目标: ${profile.mainGoal}');
      if (profile.aerobicExercises.isNotEmpty) {
        buffer.writeln('偏好有氧运动: ${profile.aerobicExercises.join(", ")}');
      }
      buffer.writeln('');
    }

    // 2. 日程安排
    final events = await _storageService.loadActiveEvents();
    if (events != null && events.isNotEmpty) {
      buffer.writeln('【当前日程安排】');
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      
      // 筛选今天和明天的日程
      final upcomingEvents = events.where((e) {
        return e.startTime.isAfter(today) && e.startTime.isBefore(tomorrow.add(const Duration(days: 1)));
      }).toList();

      if (upcomingEvents.isEmpty) {
         buffer.writeln('这两天暂无具体日程安排。');
      } else {
        // 按时间排序
        upcomingEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
        
        for (var event in upcomingEvents) {
          final isToday = event.startTime.day == today.day;
          final dateStr = isToday ? '今天' : '明天';
          final timeStr = '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}';
          final endStr = '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}';
          buffer.writeln('- $dateStr $timeStr-$endStr: ${event.title} (${event.type})');
        }
      }
    } else {
      buffer.writeln('【日程安排】\n暂无日程记录。');
    }

    return buffer.toString();
  }

  int _calculateAge(DateTime? birthday) {
    if (birthday == null) return 0;
    final now = DateTime.now();
    int age = now.year - birthday.year;
    if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
      age--;
    }
    return age;
  }
}
