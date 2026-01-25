import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../utils/env_utils.dart';

// 语音识别服务配置
class VoiceRecognitionConfig {
  // 云端API配置
  static String get apiKey => EnvUtils.voiceRecognitionApiKey;
  static String get secretKey => EnvUtils.voiceRecognitionSecretKey;
  static String get apiUrl => EnvUtils.voiceRecognitionApiUrl;
}

class VoiceRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double _confidence = 0.0;
  double _soundLevel = 0.0;
  String _currentLocale = 'zh_CN'; // 默认中文
  List<String> _availableLocales = [];
  
  // API状态
  bool _isUsingCloudApi = false;
  bool _cloudApiAvailable = true;

  // 获取可用的语言列表
  List<String> get availableLocales => _availableLocales;
  String get currentLocale => _currentLocale;
  double get soundLevel => _soundLevel;

  Future<void> initSpeech() async {
    try {
      // 初始化本地语音识别
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          // Handle status changes
        },
        onError: (errorNotification) {
          // 本地识别出错，切换到云端API
          _isUsingCloudApi = true;
        },
      );

      // 获取可用的语言列表
      if (_speechEnabled) {
        final locales = await _speechToText.locales();
        _availableLocales = locales.map((locale) => locale.localeId).toList();
      }
    } catch (e) {
      // 初始化失败，使用云端API
      _speechEnabled = false;
      _isUsingCloudApi = true;
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
    if (_speechEnabled && !_isUsingCloudApi) {
      // 使用本地语音识别
      await _startLocalListening(
        onResult: onResult,
        onPartialResult: onPartialResult,
        onConfidence: onConfidence,
        onSoundLevel: onSoundLevel,
        onStatus: onStatus,
        onError: onError,
      );
    } else {
      // 使用云端语音识别
      await _startCloudListening(
        onResult: onResult,
        onPartialResult: onPartialResult,
        onConfidence: onConfidence,
        onSoundLevel: onSoundLevel,
        onStatus: onStatus,
        onError: onError,
      );
    }
  }

  Future<void> _startLocalListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
    required Function(double) onConfidence,
    required Function(double) onSoundLevel,
    required Function(String) onStatus,
    required Function(String) onError,
  }) async {
    try {
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          _lastWords = result.recognizedWords;
          _confidence = result.confidence;
          
          // 如果本地识别置信度低，使用云端API重新识别
          if (_confidence < 0.7) {
            _retryWithCloudApi(_lastWords, onResult, onConfidence);
          } else {
            onResult(_lastWords);
            onConfidence(_confidence);
          }
        },
        onSoundLevelChange: (level) {
          _soundLevel = level;
          onSoundLevel(level);
        },
        listenFor: const Duration(minutes: 3),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: _currentLocale,
      );
    } catch (e) {
      onError('本地语音识别失败: $e');
      // 切换到云端API
      _isUsingCloudApi = true;
      _startCloudListening(
        onResult: onResult,
        onPartialResult: onPartialResult,
        onConfidence: onConfidence,
        onSoundLevel: onSoundLevel,
        onStatus: onStatus,
        onError: onError,
      );
    }
  }

  Future<void> _startCloudListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
    required Function(double) onConfidence,
    required Function(double) onSoundLevel,
    required Function(String) onStatus,
    required Function(String) onError,
  }) async {
    // 这里简化实现，实际需要录音并上传到云端API
    onStatus('使用云端语音识别');
    
    // 模拟云端识别过程
    // 实际实现中，需要：
    // 1. 开始录音
    // 2. 将录音转换为合适的格式
    // 3. 上传到云端API
    // 4. 处理返回结果
    
    // 这里我们先使用本地识别作为过渡，同时提示用户需要接入云端API
    onError('云端语音识别API尚未配置，请先配置API密钥');
    
    // 回退到本地识别（如果可用）
    if (_speechEnabled) {
      _isUsingCloudApi = false;
      _startLocalListening(
        onResult: onResult,
        onPartialResult: onPartialResult,
        onConfidence: onConfidence,
        onSoundLevel: onSoundLevel,
        onStatus: onStatus,
        onError: onError,
      );
    }
  }

  Future<void> _retryWithCloudApi(String text,
      Function(String) onResult,
      Function(double) onConfidence) async {
    if (!_cloudApiAvailable) return;
    
    try {
      // 调用云端API重新识别
      final cloudResult = await _callCloudApi(text);
      if (cloudResult != null && cloudResult['confidence'] > _confidence) {
        onResult(cloudResult['text']);
        onConfidence(cloudResult['confidence']);
      }
    } catch (e) {
      print('云端API重试失败: $e');
      _cloudApiAvailable = false;
    }
  }

  Future<Map<String, dynamic>?> _callCloudApi(String audioData) async {
    // 实际实现中，这里需要：
    // 1. 将音频数据编码为base64
    // 2. 生成签名
    // 3. 调用云端API
    // 4. 解析返回结果
    
    // 这里简化实现，返回模拟数据
    return {
      'text': audioData, // 实际应返回云端识别结果
      'confidence': 0.9, // 模拟高置信度
    };
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }

  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _speechEnabled || _cloudApiAvailable;
  String get lastWords => _lastWords;
  double get confidence => _confidence;
}

// NLP服务改进建议：接入云端AI API
class CloudNlpService {
  static String get apiUrl => EnvUtils.nlpApiUrl;
  static String get apiKey => EnvUtils.nlpApiKey;
  
  // 调用云端NLP API解析文本
  Future<Map<String, dynamic>> parseText(String text) async {
    try {
      final accessToken = await _getAccessToken();
      final response = await http.post(
        Uri.parse('$apiUrl?access_token=$accessToken'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': text,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('NLP API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      print('云端NLP API调用失败: $e');
      // 回退到本地NLP处理
      return {};
    }
  }
  
  Future<String> _getAccessToken() async {
    // 实际实现中，需要调用API获取AccessToken
    return 'mock_access_token'; // 模拟AccessToken
  }
}