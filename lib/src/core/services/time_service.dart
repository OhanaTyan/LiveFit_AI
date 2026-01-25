import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 时间显示模式枚举
enum TimeDisplayMode {
  twentyFourHour, // 24小时制
  twelveHour,     // 12小时制
}

/// 时间格式化类型枚举
enum TimeFormatType {
  standard24Hour, // 标准24小时制：HH:MM:SS
  standard12Hour, // 标准12小时制：hh:mm:ss AM/PM
  custom,         // 自定义格式
}

/// 时间观察者接口
abstract class TimeObserver {
  void onTimeUpdated(DateTime currentTime, String formattedTime);
}

/// 时间服务类
class TimeService {
  // 单例实例
  static final TimeService _instance = TimeService._internal();
  factory TimeService() => _instance;
  TimeService._internal();

  // 时间更新流控制器
  final StreamController<DateTime> _timeStreamController = StreamController<DateTime>.broadcast();
  Stream<DateTime> get timeStream => _timeStreamController.stream;

  // 观察者列表
  final List<TimeObserver> _observers = [];

  // 当前时间
  DateTime? _currentTime;
  DateTime? _cachedTime;

  // 配置参数
  TimeDisplayMode _displayMode = TimeDisplayMode.twentyFourHour;
  String _customFormat = '';
  TimeFormatType _formatType = TimeFormatType.standard24Hour;
  Duration _updateInterval = const Duration(seconds: 1);
  int _maxRetries = 3;
  int _currentRetryCount = 0;
  String _timezone = '';
  bool _useAutomaticTimezone = true;

  // 定时器
  Timer? _updateTimer;

  // 初始化服务
  Future<void> initialize() async {
    // 初始化日期符号数据
    await initializeDateFormatting();
    await _loadConfiguration();
    _startTimeUpdates();
  }

  // 加载配置
  Future<void> _loadConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeIndex = prefs.getInt('timeDisplayMode') ?? 0;
      _displayMode = TimeDisplayMode.values[modeIndex];
      _customFormat = prefs.getString('timeCustomFormat') ?? '';
      final formatTypeIndex = prefs.getInt('timeFormatType') ?? 0;
      _formatType = TimeFormatType.values[formatTypeIndex];
      // 加载时区配置
      _useAutomaticTimezone = prefs.getBool('useAutomaticTimezone') ?? true;
      _timezone = prefs.getString('timezone') ?? '';
      if (_useAutomaticTimezone) {
        // 自动检测时区
        _detectTimezone();
      }
    } catch (e) {
        // 使用默认配置
        _displayMode = TimeDisplayMode.twentyFourHour;
        _formatType = TimeFormatType.standard24Hour;
        _customFormat = '';
        _useAutomaticTimezone = true;
        _detectTimezone();
      }
  }

  // 保存配置
  Future<void> _saveConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('timeDisplayMode', _displayMode.index);
      await prefs.setString('timeCustomFormat', _customFormat);
      await prefs.setInt('timeFormatType', _formatType.index);
      // 保存时区配置
      await prefs.setBool('useAutomaticTimezone', _useAutomaticTimezone);
      await prefs.setString('timezone', _timezone);
    } catch (e) {
        // Handle error silently
      }
  }

  // 开始时间更新
  void _startTimeUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(_updateInterval, (_) => _updateTime());
    _updateTime(); // 立即更新一次
  }

  // 自动检测时区
  void _detectTimezone() {
    try {
      // 使用系统默认时区
      _timezone = DateTime.now().timeZoneName;
    } catch (e) {
      _timezone = 'UTC';
    }
  }

  // 更新时间
  void _updateTime() {
    try {
      DateTime currentTime;
      if (_useAutomaticTimezone) {
        // 使用系统当前时间
        currentTime = DateTime.now();
      } else {
        // 对于手动时区，这里使用UTC时间作为基础，实际应用中可能需要更复杂的时区转换
        // 注意：Flutter的DateTime没有内置的时区支持，实际应用中可能需要使用第三方库
        currentTime = DateTime.now().toUtc();
      }
      
      _currentTime = currentTime;
      _cachedTime = _currentTime;
      _currentRetryCount = 0;
      
      // 通知流订阅者
      _timeStreamController.add(_currentTime!);
      
      // 通知观察者
      final formattedTime = formatTime(_currentTime!);
      for (final observer in _observers) {
        observer.onTimeUpdated(_currentTime!, formattedTime);
      }
    } catch (e) {
      _handleTimeUpdateError();
    }
  }

  // 处理时间更新错误
  void _handleTimeUpdateError() {
    _currentRetryCount++;
    if (_currentRetryCount <= _maxRetries) {
      // 指数退避重试
      final delay = Duration(seconds: (2 ^ _currentRetryCount).toInt());
      Future.delayed(delay, _updateTime);
    } else {
      // 使用缓存时间
      if (_cachedTime != null) {
        // 通知流订阅者使用缓存时间
        _timeStreamController.add(_cachedTime!);
        
        // 通知观察者使用缓存时间
        final formattedTime = formatTime(_cachedTime!);
        for (final observer in _observers) {
          observer.onTimeUpdated(_cachedTime!, formattedTime);
        }
      }
    }
  }

  // 注册观察者
  void registerObserver(TimeObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  // 移除观察者
  void removeObserver(TimeObserver observer) {
    _observers.remove(observer);
  }

  // 切换时间显示模式
  Future<void> setDisplayMode(TimeDisplayMode mode) async {
    _displayMode = mode;
    // 根据显示模式自动调整格式类型
    if (mode == TimeDisplayMode.twentyFourHour) {
      _formatType = TimeFormatType.standard24Hour;
    } else {
      _formatType = TimeFormatType.standard12Hour;
    }
    await _saveConfiguration();
    // 立即更新时间以应用新模式
    _updateTime();
  }

  // 设置自定义时间格式
  Future<void> setCustomFormat(String format) async {
    _customFormat = format;
    _formatType = TimeFormatType.custom;
    await _saveConfiguration();
    // 立即更新时间以应用新格式
    _updateTime();
  }

  // 设置格式化类型
  Future<void> setFormatType(TimeFormatType type) async {
    _formatType = type;
    await _saveConfiguration();
    // 立即更新时间以应用新格式类型
    _updateTime();
  }

  // 格式化时间
  String formatTime(DateTime time) {
    try {
      switch (_formatType) {
        case TimeFormatType.standard24Hour:
          return DateFormat('HH:mm:ss').format(time);
        case TimeFormatType.standard12Hour:
          return DateFormat('hh:mm:ss a').format(time);
        case TimeFormatType.custom:
          if (_customFormat.isNotEmpty) {
            return DateFormat(_customFormat).format(time);
          } else {
            // 如果自定义格式为空，根据显示模式使用默认格式
            return _displayMode == TimeDisplayMode.twentyFourHour
                ? DateFormat('HH:mm:ss').format(time)
                : DateFormat('hh:mm:ss a').format(time);
          }
      }
    } catch (e) {
      // 格式化失败时返回默认格式
      return DateFormat('HH:mm:ss').format(time);
    }
  }

  // 获取当前时间
  DateTime? getCurrentTime() {
    return _currentTime ?? _cachedTime;
  }

  // 获取格式化后的当前时间
  String getFormattedCurrentTime() {
    final time = _currentTime ?? _cachedTime ?? DateTime.now();
    return formatTime(time);
  }

  // 时间戳转换：DateTime转Unix时间戳（毫秒）
  int dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  // 时间戳转换：Unix时间戳（毫秒）转DateTime
  DateTime timestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
  }

  // 获取当前Unix时间戳（毫秒）
  int getCurrentTimestamp() {
    final time = _currentTime ?? _cachedTime ?? DateTime.now();
    return dateTimeToTimestamp(time);
  }

  // 设置更新间隔
  void setUpdateInterval(Duration interval) {
    _updateInterval = interval;
    _startTimeUpdates(); // 重启定时器以应用新间隔
  }

  // 设置最大重试次数
  void setMaxRetries(int maxRetries) {
    _maxRetries = maxRetries;
  }

  // 设置时区自动检测
  Future<void> setAutomaticTimezone(bool automatic) async {
    _useAutomaticTimezone = automatic;
    if (automatic) {
      _detectTimezone();
    }
    await _saveConfiguration();
    _updateTime(); // 立即更新以应用新设置
  }

  // 设置手动时区
  Future<void> setTimezone(String timezone) async {
    _timezone = timezone;
    _useAutomaticTimezone = false;
    await _saveConfiguration();
    _updateTime(); // 立即更新以应用新设置
  }

  // 获取当前显示模式
  TimeDisplayMode get displayMode => _displayMode;

  // 获取当前格式类型
  TimeFormatType get formatType => _formatType;

  // 获取当前自定义格式
  String get customFormat => _customFormat;

  // 获取当前时区
  String get timezone => _timezone;

  // 获取是否使用自动时区
  bool get useAutomaticTimezone => _useAutomaticTimezone;

  // 清理资源
  void dispose() {
    _updateTimer?.cancel();
    _timeStreamController.close();
    _observers.clear();
  }
}