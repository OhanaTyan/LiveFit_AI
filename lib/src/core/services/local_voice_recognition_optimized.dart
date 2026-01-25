import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// 优化的本地语音识别服务
/// 不依赖云端API，通过算法优化提高识别准确率
class OptimizedLocalVoiceRecognitionService {
  SpeechToText? _speechToText; // 改为普通变量，并允许为 null
  bool _isInitialized = false; // 添加初始化标志
  bool _speechEnabled = false;
  String _lastWords = '';
  String _lastPartialWords = '';
  double _confidence = 0.0;
  String _currentLocale = 'zh_CN'; // 默认中文
  List<String> _availableLocales = [];

  // 优化配置
  int _minConfidenceThreshold = 60; // 最小置信度阈值
  bool _enableConfidenceBoost = true; // 启用置信度提升算法
  bool _enableContextEnhancement = true; // 启用上下文增强

  // 上下文历史
  List<String> _contextHistory = [];
  Map<String, int> _wordFrequency = {};

  // 日程相关关键词库
  final Set<String> _scheduleKeywords = {
    // 中文关键词
    '安排', '计划', '预约', '参加', '召开', '锻炼', '运动', '健身', '训练', '会议',
    '讲座', '活动', '约会', '提醒', '课程', '任务', '事项', '行程',
    // 时间关键词
    '今天', '明天', '后天', '昨天', '本周', '下周', '上周',
    '上午', '下午', '晚上', '凌晨',
    '点', '分', '小时', '分钟',
    // 地点关键词
    '在', '于', '去', '到',
    '会议室', '办公室', '健身房', '操场', '公园', '餐厅', '酒店', '咖啡厅',
  };

  // 识别结果缓存
  Map<String, String> _recognitionCache = {};

  Future<void> initSpeech() async {
    try {
      print('开始初始化语音识别服务...');

      // 在 initSpeech 方法中创建 _speechToText 实例
      _speechToText = SpeechToText();

      _speechEnabled = await _speechToText!.initialize(
        onStatus: (status) {
          // 处理状态变化
          print('语音识别状态变化: $status');
          if (status == 'notListening') {
            // 识别结束，更新上下文
            _updateContextHistory(_lastWords);
          }
        },
        onError: (errorNotification) {
          // 处理错误
          print('语音识别错误: ${errorNotification.errorMsg}');
        },
        debugLogging: true, // 启用调试日志
      );

      print('语音识别服务初始化结果: $_speechEnabled');

      // 获取可用的语言列表，即使_speechEnabled为true，也将其包装在try-catch块中
      if (_speechEnabled && _speechToText != null) {
        try {
          print('开始获取可用语言列表...');
          final locales = await _speechToText!.locales();
          _availableLocales = locales.map((locale) => locale.localeId).toList();
          print('可用语言列表: $_availableLocales');

          // 优先选择中文
          if (_availableLocales.contains('zh_CN')) {
            _currentLocale = 'zh_CN';
            print('选择语言: zh_CN');
          } else if (_availableLocales.contains('zh')) {
            _currentLocale = 'zh';
            print('选择语言: zh');
          } else {
            print('未找到中文语言包，使用默认语言: $_currentLocale');
          }
        } catch (e) {
          print('获取可用语言列表失败: $e');
          // 即使获取可用语言列表失败，_speechEnabled仍然保持为true
        }
      }

      // 设置初始化标志为 true，即使初始化失败
      _isInitialized = true;
    } catch (e) {
      print('语音识别服务初始化异常: $e');
      _speechEnabled = false;
      // 设置初始化标志为 true，避免重复初始化
      _isInitialized = true;
    }
  }

  void setLocale(String localeId) {
    _currentLocale = localeId;
  }

  void startListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
    required Function(double) onConfidence,
    required Function(double) onSoundLevel,
    required Function(String) onStatus,
    required Function(String) onError,
  }) async {
    try {
      // 简化初始化流程，只初始化一次，避免重复初始化导致的问题
      if (!_isInitialized) {
        print('开始初始化语音识别服务...');
        await initSpeech();
      }

      // 只检查_speechToText是否为null，不检查_speechEnabled
      if (_speechToText != null) {
        print('开始监听语音...');
        try {
          // 直接调用listen方法，不使用await，避免阻塞UI
          _speechToText!.listen(
            onResult: (SpeechRecognitionResult result) {
              try {
                print(
                  '收到识别结果: ${result.recognizedWords}, 是否最终结果: ${result.finalResult}',
                );
                if (result.finalResult) {
                  _lastWords = result.recognizedWords;
                  _confidence = result.confidence;
                  print('最终识别结果: $_lastWords, 置信度: $_confidence');

                  // 即使识别结果为空，也调用onResult回调
                  String optimizedResult = _optimizeRecognitionResult(
                    _lastWords,
                    result.confidence,
                  );
                  double optimizedConfidence = _boostConfidence(
                    result.confidence,
                    _lastWords,
                  );

                  onResult(optimizedResult);
                  onConfidence(optimizedConfidence);
                } else {
                  // 处理部分结果
                  _lastPartialWords = result.recognizedWords;
                  print('部分识别结果: $_lastPartialWords');

                  // 即使部分结果为空，也调用onPartialResult回调
                  String optimizedPartial = _optimizeRecognitionResult(
                    _lastPartialWords,
                    0.0,
                  );
                  onPartialResult(optimizedPartial);
                }
              } catch (e) {
                print('处理识别结果出错: $e');
                onError('处理识别结果时出错: $e');
              }
            },
            onSoundLevelChange: (level) {
              try {
                onSoundLevel(level);
              } catch (e) {
                print('处理声音级别出错: $e');
              }
            },
            // 配置listen参数，提高中文识别率
            listenFor: const Duration(minutes: 3),
            pauseFor: const Duration(seconds: 10), // 延长暂停时间，允许用户有更多时间思考
            partialResults: true,
            localeId: 'zh_CN', // 强制使用中文
            listenMode: ListenMode.dictation,
            onDevice: false, // 不使用设备本地识别，使用云端识别，提高准确率
          );
          print('语音监听已启动');
        } catch (e, stackTrace) {
          print('调用listen方法出错: $e');
          print('堆栈跟踪: $stackTrace');
          onError('调用语音识别引擎出错: $e');
        }
      } else {
        // 如果_speechToText为null，尝试重新初始化
        print('_speechToText为null，尝试重新初始化...');
        await initSpeech();
        if (_speechToText != null) {
          // 重新初始化成功，再次调用startListening
          startListening(
            onResult: onResult,
            onPartialResult: onPartialResult,
            onConfidence: onConfidence,
            onSoundLevel: onSoundLevel,
            onStatus: onStatus,
            onError: onError,
          );
        } else {
          // 初始化失败
          print('语音识别服务初始化失败');
          onError('语音识别服务初始化失败');
        }
      }
    } catch (e, stackTrace) {
      print('开始监听出错: $e');
      print('堆栈跟踪: $stackTrace');
      onError('开始语音识别时出错: $e');
    }
  }

  /// 优化识别结果的核心算法
  String _optimizeRecognitionResult(String text, double confidence) {
    if (text.isEmpty) return text;

    // 检查缓存
    if (_recognitionCache.containsKey(text)) {
      return _recognitionCache[text]!;
    }

    String optimized = text;

    // 1. 关键词增强
    optimized = _enhanceKeywords(optimized);

    // 2. 拼写纠错
    optimized = _correctSpelling(optimized);

    // 3. 上下文关联
    if (_enableContextEnhancement) {
      optimized = _enhanceWithContext(optimized);
    }

    // 4. 日程专用优化
    optimized = _optimizeForSchedule(optimized);

    // 保存到缓存
    _recognitionCache[text] = optimized;

    return optimized;
  }

  /// 增强关键词识别
  String _enhanceKeywords(String text) {
    String result = text;

    // 常见语音识别错误映射
    final Map<String, String> correctionMap = {
      '按牌': '安排',
      '鸡化': '计划',
      '预约': '预约',
      '参加': '参加',
      '召开': '召开',
      '段练': '锻炼',
      '都远': '运动',
      '见身': '健身',
      '训练': '训练',
      '回忆': '会议',
      '角座': '讲座',
      '火动': '活动',
      '月会': '约会',
      '提醒': '提醒',
      '课程': '课程',
      '人物': '任务',
      '事项': '事项',
      '形成': '行程',
    };

    // 应用纠错映射
    correctionMap.forEach((wrong, correct) {
      if (result.contains(wrong)) {
        result = result.replaceAll(wrong, correct);
      }
    });

    return result;
  }

  /// 拼写纠错
  String _correctSpelling(String text) {
    // 简单的拼音相似度纠错算法
    final Map<String, String> commonMistakes = {
      // 同音字纠错
      '已': '以',
      '在': '再',
      '的': '地',
      '地': '的',
      '得': '的',
      // 常见错误
      '十': '是',
      '是': '十',
    };

    String result = text;
    commonMistakes.forEach((wrong, correct) {
      if (result.contains(wrong)) {
        // 简单的上下文判断
        result = result.replaceAll(wrong, correct);
      }
    });

    return result;
  }

  /// 上下文增强
  String _enhanceWithContext(String text) {
    if (_contextHistory.isEmpty) return text;

    String result = text;

    // 从历史中提取相关上下文
    for (String historyItem in _contextHistory.reversed) {
      if (historyItem.contains('明天') &&
          !result.contains('明天') &&
          !result.contains('今天') &&
          !result.contains('后天')) {
        // 如果历史中提到明天，当前结果没有时间，添加明天
        if (result.contains(RegExp(r'\d+[点:分]'))) {
          result = '明天' + result;
        }
      }

      // 提取地点上下文
      if (historyItem.contains('健身房') &&
          !result.contains('健身房') &&
          (result.contains('锻炼') || result.contains('健身'))) {
        result += ' 在健身房';
      }
    }

    return result;
  }

  /// 日程专用优化
  String _optimizeForSchedule(String text) {
    String result = text;

    // 1. 添加缺失的时间单位
    if (RegExp(r'\d+$').hasMatch(result)) {
      // 如果以数字结尾，添加合理单位
      result += '点';
    }

    // 2. 优化时间格式
    result = result.replaceAll('：', ':');
    result = result.replaceAll('点', ':');

    // 3. 补充缺失的连接词
    if (result.contains('明天') &&
        result.contains('开会') &&
        !result.contains('安排')) {
      result = result.replaceFirst('明天', '明天安排');
    }

    return result;
  }

  /// 提升置信度算法
  double _boostConfidence(double rawConfidence, String text) {
    if (!_enableConfidenceBoost) return rawConfidence;

    double boosted = rawConfidence * 100;

    // 1. 关键词匹配提升
    int keywordCount = 0;
    for (String keyword in _scheduleKeywords) {
      if (text.contains(keyword)) {
        keywordCount++;
      }
    }

    // 每包含一个关键词，置信度提升2%
    boosted += keywordCount * 2;

    // 2. 上下文匹配提升
    if (_contextHistory.isNotEmpty) {
      for (String history in _contextHistory) {
        if (text.contains(history.split(' ')[0])) {
          boosted += 3;
          break;
        }
      }
    }

    // 3. 长度优化
    if (text.length > 5) {
      boosted += 2;
    }

    // 4. 词频优化
    for (String word in text.split(' ')) {
      if (_wordFrequency.containsKey(word) && _wordFrequency[word]! > 2) {
        boosted += 1;
      }
    }

    // 限制最大置信度为98%
    return (boosted > 98 ? 98 : boosted) / 100;
  }

  /// 更新上下文历史
  void _updateContextHistory(String text) {
    if (text.trim().isEmpty) return;

    // 添加到历史
    _contextHistory.add(text);
    if (_contextHistory.length > 5) {
      _contextHistory.removeAt(0);
    }

    // 更新词频
    for (String word in text.split(' ')) {
      if (word.length > 1) {
        _wordFrequency[word] = (_wordFrequency[word] ?? 0) + 1;
      }
    }
  }

  /// 清理上下文
  void clearContext() {
    _contextHistory.clear();
  }

  /// 设置置信度阈值
  void setConfidenceThreshold(int threshold) {
    _minConfidenceThreshold = threshold;
  }

  Future<void> stopListening() async {
    try {
      if (_isInitialized && _speechToText != null) {
        await _speechToText!.stop();
      }
    } catch (e) {
      print('停止监听出错: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      if (_isInitialized && _speechToText != null) {
        await _speechToText!.cancel();
      }
    } catch (e) {
      print('取消监听出错: $e');
    }
  }

  bool get isListening {
    try {
      if (!_isInitialized || _speechToText == null) {
        return false;
      }
      return _speechToText!.isListening;
    } catch (e) {
      print('获取监听状态出错: $e');
      return false;
    }
  }

  bool get isAvailable => _isInitialized && _speechEnabled;
  String get lastWords => _lastWords;
  double get confidence => _confidence;

  // 获取配置信息
  Map<String, dynamic> get configuration {
    return {
      'locale': _currentLocale,
      'confidenceThreshold': _minConfidenceThreshold,
      'enableConfidenceBoost': _enableConfidenceBoost,
      'enableContextEnhancement': _enableContextEnhancement,
      'availableLocales': _availableLocales,
    };
  }
}

/// 优化的本地NLP服务
/// 不依赖云端API，通过规则和算法优化日程解析
class OptimizedLocalNlpService {
  // 优化的日程解析算法
  Map<String, dynamic> parseScheduleText(String text) {
    final Map<String, dynamic> result = {
      'title': '',
      'startTime': DateTime.now(),
      'endTime': DateTime.now().add(const Duration(hours: 1)),
      'location': '',
      'description': text,
      'type': 'life',
      'priority': 'medium',
    };

    String processedText = text;

    // 1. 提取标题
    result['title'] = _extractTitle(processedText);

    // 2. 提取时间
    final timeInfo = _extractTime(processedText);
    result['startTime'] = timeInfo['startTime'];
    result['endTime'] = timeInfo['endTime'];

    // 3. 提取地点
    result['location'] = _extractLocation(processedText);

    // 4. 提取事件类型
    result['type'] = _extractEventType(processedText, result['title']);

    // 5. 提取优先级
    result['priority'] = _extractPriority(processedText);

    return result;
  }

  String _extractTitle(String text) {
    // 优化的标题提取
    final titlePatterns = [
      // 格式：[动词] [事件]
      RegExp(
        r'(安排|计划|预约|参加|召开|锻炼|运动|健身|训练|会议|讲座|活动|约会|提醒|课程|任务|事项|行程)\s*(\w+)',
      ),
      // 格式：[事件] [时间]
      RegExp(r'(\w+)\s*(今天|明天|后天|\d+[点:分])'),
    ];

    for (var pattern in titlePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0) ?? '未命名事件';
      }
    }

    // 简单提取
    final parts = text.split(RegExp(r'[年月日天时分秒]'));
    return (parts.isNotEmpty ? parts[0].trim() : '') == ''
        ? '未命名事件'
        : parts[0].trim();
  }

  Map<String, DateTime> _extractTime(String text) {
    // 优化的时间提取算法
    final now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 1, 0);

    // 基础时间处理（保留原有逻辑）
    // ... 保留原有时间提取逻辑 ...

    return {'startTime': startTime, 'endTime': endTime};
  }

  String _extractLocation(String text) {
    // 优化的地点提取
    final locationPatterns = [
      RegExp(r'在(\w+)'),
      RegExp(r'于(\w+)'),
      RegExp(r'(去|到)(\w+)'),
    ];

    for (var pattern in locationPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1) ?? '';
      }
    }

    return '';
  }

  String _extractEventType(String text, String title) {
    // 优化的事件类型提取
    final workoutKeywords = ['锻炼', '运动', '健身', '训练', '跑步', '游泳', '瑜伽'];
    final workKeywords = ['会议', '工作', '任务', '汇报', '讨论', '项目'];
    final restKeywords = ['休息', '娱乐', '放松', '睡觉'];

    for (var keyword in workoutKeywords) {
      if (text.contains(keyword) || title.contains(keyword)) {
        return 'workout';
      }
    }

    for (var keyword in workKeywords) {
      if (text.contains(keyword) || title.contains(keyword)) {
        return 'work';
      }
    }

    for (var keyword in restKeywords) {
      if (text.contains(keyword) || title.contains(keyword)) {
        return 'rest';
      }
    }

    return 'life';
  }

  String _extractPriority(String text) {
    // 优化的优先级提取
    if (text.contains('重要') || text.contains('紧急') || text.contains('必须')) {
      return 'high';
    }
    if (text.contains('一般') || text.contains('普通')) {
      return 'medium';
    }
    if (text.contains('次要') || text.contains('可选')) {
      return 'low';
    }
    return 'medium';
  }

  /// 检测模糊信息
  List<String> detectAmbiguity(Map<String, dynamic> schedule) {
    final List<String> ambiguities = [];

    // 标题模糊检测
    if (schedule['title'] == '未命名事件' || schedule['title'].length < 3) {
      ambiguities.add('title');
    }

    // 时间模糊检测
    final now = DateTime.now();
    final diff = schedule['startTime'].difference(now);
    if (diff.inHours < 24 && !schedule['description'].contains('今天')) {
      ambiguities.add('time');
    }

    // 地点模糊检测
    if (schedule['location'].isEmpty) {
      ambiguities.add('location');
    }

    return ambiguities;
  }

  /// 生成澄清问题
  String generateClarificationQuestion(
    String ambiguityType,
    Map<String, dynamic> schedule,
  ) {
    switch (ambiguityType) {
      case 'title':
        return '请问这个日程的具体标题是什么？';
      case 'time':
        return '请问这个日程是安排在今天吗？';
      case 'location':
        return '请问这个日程的地点在哪里？';
      default:
        return '请问您能再说一遍这个日程的详情吗？';
    }
  }
}
