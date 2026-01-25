import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/env_utils.dart';

class AiService {
  // DeepSeek AI模型配置
  final String _apiBaseUrl;
  final String _apiKey;

  final http.Client _httpClient;
  final Connectivity _connectivity;

  AiService({
    http.Client? httpClient,
    Connectivity? connectivity,
    String? apiBaseUrl,
    String? apiKey,
  }) : _httpClient = httpClient ?? http.Client(),
       _connectivity = connectivity ?? Connectivity(),
       _apiBaseUrl =
           apiBaseUrl ??
           EnvUtils.get(
             'DEEPSEEK_API_BASE_URL',
             defaultValue: 'https://api.deepseek.com/v1/chat/completions',
           )!,
       _apiKey = apiKey ?? EnvUtils.get('DEEPSEEK_API_KEY', defaultValue: '')!;

  // 检测网络连接状态
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        !results.every((result) => result == ConnectivityResult.none);
  }

  // 调用大模型API（DeepSeek）
  Future<dynamic> _callApi(String prompt) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse(_apiBaseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': 'deepseek-chat', // DeepSeek聊天模型
              'messages': [
                {
                  'role': 'system',
                  'content':
                      '你是一个智能的日程管理助手，能够准确识别和解析用户的日程请求。请以JSON格式返回结果，包含title、startTime、endTime、location、description、priority、type等字段。',
                },
                {'role': 'user', 'content': prompt},
              ],
              'temperature': 0.3,
              'response_format': {'type': 'json_object'},
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return jsonDecode(data['choices'][0]['message']['content']);
      } else {
        throw Exception('API调用失败: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('API调用出错: $e');
    }
  }

  // 识别内容
  Future<Map<String, dynamic>> recognizeContent(String text) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    final prompt =
        '''请分析以下文本，识别其类型和关键信息：

$text

请以JSON格式返回结果，包含：
- type: 内容类型（如schedule、question、plan等）
- content: 原始内容
- keywords: 关键词列表
- summary: 简要总结''';

    final result = await _callApi(prompt);
    return result as Map<String, dynamic>;
  }

  // 回答问题
  Future<String> answerQuestion(String question, {String? context}) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    final prompt = context != null
        ? '''基于以下上下文回答问题：

上下文：$context

问题：$question

请直接给出简洁准确的答案，不要添加任何额外解释。'''
        : '''请回答以下问题：

$question

请直接给出简洁准确的答案，不要添加任何额外解释。''';

    final result = await _callApi(prompt);
    if (result is Map<String, dynamic>) {
      return result['answer'] ?? result.toString();
    }
    return result.toString();
  }

  // 导入计划
  Future<List<Map<String, dynamic>>> importPlan(String text) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    final prompt =
        '''请从以下文本中提取所有日程计划：

$text

每个日程计划请包含：
- title: 事件标题
- startTime: 开始时间（ISO格式）
- endTime: 结束时间（ISO格式）
- location: 地点（如果有）
- description: 详细描述
- priority: 优先级（high、medium、low）
- type: 事件类型（workout、work、rest、life）

请以JSON数组格式返回所有提取的日程计划。''';

    final result = await _callApi(prompt);

    // 检查result是否直接是一个列表
    if (result is List) {
      return List<Map<String, dynamic>>.from(result);
    }

    // 否则，尝试从schedules字段获取列表
    return List<Map<String, dynamic>>.from(result['schedules'] ?? []);
  }

  // 从文本中提取日程事件（集成到现有NLP服务）
  Future<List<Map<String, dynamic>>> extractScheduleEvents(String text) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    return await importPlan(text);
  }

  // 解析单个事件
  Future<Map<String, dynamic>?> parseSingleEvent(String text) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    final prompt =
        '''请解析以下单个日程事件：

$text

请提取：
- title: 事件标题
- startTime: 开始时间（ISO格式）
- endTime: 结束时间（ISO格式）
- location: 地点（如果有）
- description: 详细描述
- priority: 优先级（high、medium、low）
- type: 事件类型（workout、work、rest、life）

请以JSON格式返回结果。''';

    final result = await _callApi(prompt);
    return result as Map<String, dynamic>?;
  }

  // 智能生成澄清问题
  Future<String> generateClarificationQuestion(
    String ambiguityType,
    Map<String, dynamic> schedule,
    String originalText,
  ) async {
    final isOnline = await isConnected();
    if (!isOnline) {
      throw Exception('未连接到网络');
    }

    final prompt =
        '''你是一个智能的日程管理助手，需要根据用户的原始输入和当前解析的日程信息，生成一个自然、相关的澄清问题。

原始文本：$originalText

当前解析的日程：${jsonEncode(schedule)}

需要澄清的信息类型：$ambiguityType

请生成一个自然、友好的问题，引导用户补充缺失的信息。问题应该具体、有针对性，不要使用固定模板，要结合上下文生成。

例如：
- 如果原始文本是"明天去跑步"，需要澄清地点，应该问："请问你明天计划在哪里跑步？"
- 如果原始文本是"下午开会"，需要澄清时间，应该问："请问会议具体是下午几点开始？"

请直接返回问题，不要添加任何其他内容。''';

    final result = await _callApi(prompt);
    if (result is Map<String, dynamic>) {
      return result['question'] ?? result.toString();
    }
    return result.toString();
  }
}
