import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 环境变量管理工具类
/// 用于加载和访问应用程序的环境变量
class EnvUtils {
  static bool _isLoaded = false;

  /// 初始化环境变量
  /// 应在应用启动时调用
  static Future<void> initialize() async {
    if (!_isLoaded) {
      try {
        await dotenv.load();
      } catch (e) {
        // 环境变量文件加载失败，继续执行，使用默认值
        print('环境变量加载失败: $e');
      }
      _isLoaded = true;
    }
  }

  /// 获取环境变量值
  /// 如果环境变量不存在，返回默认值或null
  static String? get(String key, {String? defaultValue}) {
    if (!_isLoaded) {
      return defaultValue;
    }
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      // dotenv未正确初始化，返回默认值
      print('访问环境变量失败: $e');
      return defaultValue;
    }
  }

  /// 获取环境变量值，如果不存在则抛出异常
  static String getOrThrow(String key) {
    final value = get(key);
    if (value == null) {
      throw Exception('环境变量 $key 未配置');
    }
    return value;
  }

  /// DeepSeek AI API配置
  static String get deepseekApiKey => get('DEEPSEEK_API_KEY', defaultValue: 'your_deepseek_api_key')!;
  static String get deepseekApiBaseUrl => 
      get('DEEPSEEK_API_BASE_URL', defaultValue: 'https://api.deepseek.com/v1/chat/completions')!;

  /// 语音识别API配置
  static String get voiceRecognitionApiKey => get('VOICE_RECOGNITION_API_KEY', defaultValue: 'your_api_key')!;
  static String get voiceRecognitionSecretKey => get('VOICE_RECOGNITION_SECRET_KEY', defaultValue: 'your_secret_key')!;
  static String get voiceRecognitionApiUrl => get('VOICE_RECOGNITION_API_URL', defaultValue: 'https://vop.baidu.com/server_api')!;

  /// 天气API配置
  static String get weatherApiBaseUrl => get('WEATHER_API_BASE_URL', defaultValue: 'https://api.open-meteo.com/v1')!;
  static String get geocodingApiBaseUrl => get('GEOCODING_API_BASE_URL', defaultValue: 'https://nominatim.openstreetmap.org')!;

  /// NLP服务配置
  static String get nlpApiUrl => get('NLP_API_URL', defaultValue: 'https://aip.baidubce.com/rpc/2.0/nlp/v1/lexer')!;
  static String get nlpApiKey => get('NLP_API_KEY', defaultValue: 'your_api_key')!;

  /// 检查环境变量是否已加载
  static bool get isLoaded => _isLoaded;
}
