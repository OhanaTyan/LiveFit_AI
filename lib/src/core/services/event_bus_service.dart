import 'dart:async';

class EventBusService {
  static EventBusService? _instance;
  final _controller = StreamController<dynamic>.broadcast();

  factory EventBusService() {
    _instance ??= EventBusService._internal();
    return _instance!;
  }

  EventBusService._internal();

  // 事件类型
  static const String eventScheduleUpdated = 'schedule_updated';
  static const String eventUserPreferenceChanged = 'user_preference_changed';
  static const String eventWeatherUpdated = 'weather_updated';
  static const String eventSuggestionGenerated = 'suggestion_generated';

  // 发送事件
  void fireEvent(String eventType, [dynamic data]) {
    _controller.add({'type': eventType, 'data': data});
  }

  // 监听事件
  Stream<dynamic> onEvent(String eventType) {
    return _controller.stream.where((event) => event['type'] == eventType);
  }

  // 关闭事件总线
  void dispose() {
    _controller.close();
  }
}
