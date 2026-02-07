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
}
