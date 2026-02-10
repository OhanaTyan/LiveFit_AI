import '../../domain/models/chat_message.dart';
import '../../domain/services/ai_service.dart';

class EchoService implements AiService {
  @override
  Future<String> sendMessage(List<ChatMessage> history, String message, {String? systemContext}) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));
    return 'Echo: $message\n(Context: ${systemContext != null ? "Yes" : "No"})';
  }

  @override
  Stream<String> streamMessage(List<ChatMessage> history, String message, {String? systemContext}) async* {
    await Future.delayed(const Duration(seconds: 1));
    yield 'Echo: $message';
  }

  @override
  Future<bool> isConnected() async {
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> extractScheduleEvents(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<Map<String, dynamic>?> parseSingleEvent(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }

  @override
  Future<String> generateClarificationQuestion(
    String ambiguityType,
    Map<String, dynamic> schedule,
    String originalText,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return '这是一个模拟的澄清问题。';
  }
}
