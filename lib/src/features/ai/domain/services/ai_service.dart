import '../models/chat_message.dart';

abstract class AiService {
  /// 发送消息并获取回复
  /// [history] 历史消息列表
  /// [message] 当前用户输入的消息
  /// [systemContext] 可选的系统上下文（如用户资料、日程等），用于增强 AI 的回答
  Future<String> sendMessage(List<ChatMessage> history, String message, {String? systemContext});
  
  /// 发送消息并获取流式回复（可选实现）
  Stream<String> streamMessage(List<ChatMessage> history, String message, {String? systemContext});

  /// 检查网络连接状态
  Future<bool> isConnected();

  /// 从文本中提取日程事件
  Future<List<Map<String, dynamic>>> extractScheduleEvents(String text);

  /// 解析单个日程事件
  Future<Map<String, dynamic>?> parseSingleEvent(String text);

  /// 生成澄清问题
  Future<String> generateClarificationQuestion(
    String ambiguityType,
    Map<String, dynamic> schedule,
    String originalText,
  );
}
