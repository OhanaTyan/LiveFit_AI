import 'package:logger/logger.dart';

/// 日志服务类，用于统一管理日志记录
class LogService {
  /// 单例实例
  static final LogService _instance = LogService._internal();
  
  /// 日志记录器
  late final Logger _logger;
  
  /// 工厂构造函数，返回单例实例
  factory LogService() {
    return _instance;
  }
  
  /// 内部构造函数
  LogService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }
  
  /// 记录详细日志
  void verbose(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }
  
  /// 记录调试日志
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }
  
  /// 记录信息日志
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }
  
  /// 记录警告日志
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }
  
  /// 记录错误日志
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
  
  /// 记录致命错误日志
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

/// 日志服务实例，方便全局使用
final log = LogService();
