import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/config/app_secrets.dart';
import '../../../../core/services/log_service.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/services/ai_service.dart';

class SiliconFlowService implements AiService {
  static const String _baseUrl = 'https://api.siliconflow.cn/v1';
  // 使用 Qwen2.5-7B-Instruct 作为默认模型，因为它通常比较稳定且便宜
  // 用户可以在此处更改为 'deepseek-ai/DeepSeek-V3' 等其他模型
  static const String _model = 'deepseek-ai/DeepSeek-V3'; 
  
  final Connectivity _connectivity = Connectivity();

  @override
  Future<String> sendMessage(List<ChatMessage> history, String message, {String? systemContext}) async {
    final messages = _buildMessages(history, message, systemContext);

    try {
      log.info('Sending request to SiliconFlow API...');
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppSecrets.siliconFlowToken}',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'stream': false,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['choices'] != null && (data['choices'] as List).isNotEmpty) {
           final content = data['choices'][0]['message']['content'] as String;
           return content;
        } else {
           throw Exception('Empty response choices');
        }
      } else {
        log.error('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      log.error('Exception during AI request: $e');
      throw Exception('Error communicating with AI: $e');
    }
  }

  @override
  Stream<String> streamMessage(List<ChatMessage> history, String message, {String? systemContext}) async* {
    // 暂时回退到非流式调用，但在 Stream 中返回
    // 未来可在此处实现 SSE 解析
    try {
      final content = await sendMessage(history, message, systemContext: systemContext);
      yield content;
    } catch (e) {
      yield 'Error: $e';
    }
  }

  @override
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        !results.every((result) => result == ConnectivityResult.none);
  }

  @override
  Future<List<Map<String, dynamic>>> extractScheduleEvents(String text) async {
    final prompt = '''请从以下文本中提取所有日程计划：
      
$text

每个日程计划请包含：
- title: 事件标题
- startTime: 开始时间（ISO格式）
- endTime: 结束时间（ISO格式）
- location: 地点（如果有）
- description: 详细描述
- priority: 优先级（high、medium、low）
- type: 事件类型（workout、work、rest、life）

请以JSON数组格式返回所有提取的日程计划。只返回JSON，不要包含markdown格式标记或其他解释。''';

    try {
      final response = await sendMessage([], prompt);
      
      // 尝试提取 JSON 部分
      String jsonStr = response;
      final jsonStart = response.indexOf('[');
      final jsonEnd = response.lastIndexOf(']');
      
      if (jsonStart != -1 && jsonEnd != -1) {
        jsonStr = response.substring(jsonStart, jsonEnd + 1);
      }
      
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return List<Map<String, dynamic>>.from(jsonList);
    } catch (e) {
      log.error('Failed to extract schedule events: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> parseSingleEvent(String text) async {
    final prompt = '''请解析以下单个日程事件：

$text

请提取：
- title: 事件标题
- startTime: 开始时间（ISO格式）
- endTime: 结束时间（ISO格式）
- location: 地点（如果有）
- description: 详细描述
- priority: 优先级（high、medium、low）
- type: 事件类型（workout、work、rest、life）

请以JSON格式返回结果。只返回JSON，不要包含markdown格式标记或其他解释。''';

    try {
      final response = await sendMessage([], prompt);
      
      // 尝试提取 JSON 部分
      String jsonStr = response;
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}');
      
      if (jsonStart != -1 && jsonEnd != -1) {
        jsonStr = response.substring(jsonStart, jsonEnd + 1);
      }
      
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      log.error('Failed to parse single event: $e');
      return null;
    }
  }

  @override
  Future<String> generateClarificationQuestion(
    String ambiguityType,
    Map<String, dynamic> schedule,
    String originalText,
  ) async {
    final prompt = '''你是一个智能的日程管理助手，需要根据用户的原始输入和当前解析的日程信息，生成一个自然、相关的澄清问题。

原始文本：$originalText

当前解析的日程：${jsonEncode(schedule)}

需要澄清的信息类型：$ambiguityType

请生成一个自然、友好的问题，引导用户补充缺失的信息。问题应该具体、有针对性，不要使用固定模板，要结合上下文生成。

例如：
- 如果原始文本是"明天去跑步"，需要澄清地点，应该问："请问你明天计划在哪里跑步？"
- 如果原始文本是"下午开会"，需要澄清时间，应该问："请问会议具体是下午几点开始？"

请直接返回问题，不要添加任何其他内容。''';

    try {
      final response = await sendMessage([], prompt);
      // 如果返回的是JSON对象包含question字段（为了兼容性），尝试解析，否则直接返回文本
      try {
         final json = jsonDecode(response);
         if (json is Map && json.containsKey('question')) {
           return json['question'];
         }
      } catch (_) {
        // Not a JSON object, treat as plain text
      }
      return response.trim();
    } catch (e) {
      log.error('Failed to generate clarification question: $e');
      return '请问能提供更多细节吗？';
    }
  }

  List<Map<String, String>> _buildMessages(List<ChatMessage> history, String currentMessage, String? systemContext) {
    final List<Map<String, String>> messages = [];
    
    // Base System Prompt
    String systemPrompt = '''你是 LifeFit AI，一个专业的日程管理和健身助手。请用中文回答用户的问题，语气亲切自然，专注于帮助用户规划日程和提供运动建议。

当你需要帮助用户修改、添加或删除日程时，请不要直接回复纯文本，而是返回一个特定的JSON代码块，格式如下：
```json
{
  "tool_call": "manage_schedule",
  "action": "create" | "update" | "delete",
  "event": {
    "title": "事件标题",
    "startTime": "ISO格式时间",
    "endTime": "ISO格式时间",
    "type": "workout | work | life | rest",
    "description": "描述"
  },
  "reason": "操作原因说明"
}
```
请确保只在用户明确要求或上下文中暗示需要修改日程时才使用此功能。''';
    
    // Append Context if available
    if (systemContext != null && systemContext.isNotEmpty) {
      systemPrompt += '\n\n当前用户上下文信息（请基于此信息提供个性化建议）：\n$systemContext';
    }

    messages.add({
      'role': 'system',
      'content': systemPrompt,
    });

    // History (限制最近 10 条以节省 Token)
    final recentHistory = history.length > 10 
        ? history.sublist(history.length - 10) 
        : history;

    for (var msg in recentHistory) {
      messages.add({
        'role': msg.type == MessageType.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // Current Message
    messages.add({
      'role': 'user',
      'content': currentMessage,
    });

    return messages;
  }
}
