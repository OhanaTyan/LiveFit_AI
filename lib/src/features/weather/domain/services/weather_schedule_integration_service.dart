import 'package:life_fit/src/features/schedule/domain/models/schedule_event.dart';
import 'package:life_fit/src/features/weather/domain/models/weather_data.dart';
import 'package:life_fit/src/features/weather/utils/exercise_suitability_calculator.dart';

class WeatherScheduleIntegrationService {
  // 根据天气状况调整日程
  List<ScheduleEvent> adjustScheduleForWeather(
    List<ScheduleEvent> events,
    WeatherData weather,
  ) {
    final adjustedEvents = <ScheduleEvent>[];
    
    for (final event in events) {
      // 检查事件是否为户外锻炼
      if (event.type == EventType.workout && _isOutdoorEvent(event)) {
        // 评估当前天气是否适合该活动
        final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
        
        // 如果天气不适合，调整活动
        if (recommendation.suitability.index > 1) { // moderatelySuitable 或 unsuitable
          final adjustedEvent = _adjustOutdoorWorkoutForWeather(event, weather, recommendation);
          adjustedEvents.add(adjustedEvent);
        } else {
          adjustedEvents.add(event);
        }
      } else {
        adjustedEvents.add(event);
      }
    }
    
    return adjustedEvents;
  }
  
  // 判断事件是否为户外活动
  bool _isOutdoorEvent(ScheduleEvent event) {
    // 基于事件标题、描述或位置判断是否为户外活动
    final lowerCaseTitle = event.title.toLowerCase();
    final lowerCaseDesc = event.description.toLowerCase();
    
    // 常见户外活动关键词
    final outdoorKeywords = [
      '跑', '跑', '户外', '公园', '操场', '骑行', '徒步', '爬山', '足球', '篮球', '网球', '羽毛球',
      'outdoor', 'run', 'jog', 'walk', 'hike', 'cycle', 'bike', 'playground', 'park',
    ];
    
    // 检查标题或描述中是否包含户外活动关键词
    for (final keyword in outdoorKeywords) {
      if (lowerCaseTitle.contains(keyword) || lowerCaseDesc.contains(keyword)) {
        return true;
      }
    }
    
    // 检查位置是否包含户外相关词汇
    if (event.location != null) {
      final lowerCaseLocation = event.location!.toLowerCase();
      for (final keyword in outdoorKeywords) {
        if (lowerCaseLocation.contains(keyword)) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  // 根据天气调整户外锻炼
  ScheduleEvent _adjustOutdoorWorkoutForWeather(
    ScheduleEvent event,
    WeatherData weather,
    dynamic recommendation,
  ) {
    // 根据天气状况生成调整后的活动标题和描述
    String adjustedTitle = event.title;
    String adjustedDescription = event.description;
    
    // 检查具体天气状况并调整活动
    if (weather.iconCode.contains('rain')) {
      // 雨天：将户外活动改为室内
      adjustedTitle = event.title.replaceAll(RegExp(r'户外|室外', caseSensitive: false), '室内');
      adjustedDescription = '因雨天调整为室内活动：${event.description}';
    } else if (weather.temperature > 32) {
      // 高温：调整为低强度活动
      adjustedTitle = event.title.replaceAll(RegExp(r'高强度|HIIT|快跑', caseSensitive: false), '低强度');
      adjustedDescription = '因高温调整为低强度活动：${event.description}';
    } else if (weather.temperature < 5) {
      // 低温：添加保暖建议
      adjustedDescription = '${event.description}（低温注意保暖）';
    } else if (weather.aqi != null && weather.aqi! > 150) {
      // 空气质量差：改为室内活动
      adjustedTitle = event.title.replaceAll(RegExp(r'户外|室外', caseSensitive: false), '室内');
      adjustedDescription = '因空气质量不佳调整为室内活动：${event.description}';
    }
    
    // 返回调整后的事件
    return ScheduleEvent(
      id: event.id,
      title: adjustedTitle,
      description: adjustedDescription,
      startTime: event.startTime,
      endTime: event.endTime,
      type: event.type,
      color: event.color,
      isCompleted: event.isCompleted,
      priority: event.priority,
      location: _adjustLocationForWeather(event.location, weather),
      recurrence: event.recurrence,
      recurrenceEnd: event.recurrenceEnd,
    );
  }
  
  // 根据天气调整活动位置
  String? _adjustLocationForWeather(String? originalLocation, WeatherData weather) {
    if (originalLocation == null) return null;
    
    // 如果天气不适合户外活动，将位置改为室内
    final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
    
    if (recommendation.suitability.index > 1) { // moderatelySuitable 或 unsuitable
      return '室内';
    }
    
    return originalLocation;
  }
  
  // 基于天气推荐活动
  List<Map<String, dynamic>> getWeatherBasedActivityRecommendations(
    WeatherData weather,
    List<ScheduleEvent> events,
  ) {
    final recommendations = <Map<String, dynamic>>[];
    
    // 根据天气状况生成推荐活动
    final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
    
    // 推荐适合当前天气的活动
    if (recommendation.isOutdoorRecommended) {
      recommendations.addAll([
        {
          'title': '户外散步',
          'description': '当前天气适合户外活动，建议进行30分钟的户外散步',
          'type': 'workout',
          'duration': 30,
          'priority': EventPriority.medium,
        },
        {
          'title': '户外骑行',
          'description': '阳光明媚，适合骑行锻炼',
          'type': 'workout',
          'duration': 45,
          'priority': EventPriority.medium,
        },
      ]);
    } else if (weather.iconCode.contains('rain')) {
      recommendations.addAll([
        {
          'title': '室内瑜伽',
          'description': '雨天适合室内瑜伽练习，放松身心',
          'type': 'workout',
          'duration': 30,
          'priority': EventPriority.medium,
        },
        {
          'title': '室内HIIT训练',
          'description': '无需器械，在家即可进行高效燃脂训练',
          'type': 'workout',
          'duration': 20,
          'priority': EventPriority.medium,
        },
      ]);
    } else if (weather.temperature > 32) {
      recommendations.addAll([
        {
          'title': '室内游泳',
          'description': '高温天气，游泳是消暑健身的好选择',
          'type': 'workout',
          'duration': 45,
          'priority': EventPriority.medium,
        },
        {
          'title': '清晨慢跑',
          'description': '建议在清晨气温较低时进行慢跑',
          'type': 'workout',
          'duration': 30,
          'priority': EventPriority.medium,
        },
      ]);
    } else if (weather.temperature < 5) {
      recommendations.addAll([
        {
          'title': '室内力量训练',
          'description': '低温天气适合室内力量训练，增强体质',
          'type': 'workout',
          'duration': 40,
          'priority': EventPriority.medium,
        },
        {
          'title': '热瑜伽',
          'description': '热瑜伽可以帮助身体保暖，提高柔韧性',
          'type': 'workout',
          'duration': 30,
          'priority': EventPriority.medium,
        },
      ]);
    }
    
    return recommendations;
  }
  
  // 检查即将到来的户外活动是否需要调整
  List<Map<String, dynamic>> checkUpcomingOutdoorActivities(
    List<ScheduleEvent> events,
    WeatherData weather,
  ) {
    final alerts = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    // 检查未来24小时内的户外活动
    final upcomingEvents = events.where((event) {
      final timeDiff = event.startTime.difference(now);
      return event.type == EventType.workout && 
             _isOutdoorEvent(event) && 
             timeDiff > Duration.zero && 
             timeDiff < const Duration(hours: 24);
    }).toList();
    
    for (final event in upcomingEvents) {
      final recommendation = ExerciseSuitabilityCalculator.calculateSuitability(weather);
      
      if (recommendation.suitability.index > 1) { // moderatelySuitable 或 unsuitable
        alerts.add({
          'event': event,
          'weather': weather,
          'suitability': recommendation.suitability,
          'message': '天气可能影响您的户外活动：${event.title}',
          'recommendation': recommendation.recommendationKey,
        });
      }
    }
    
    return alerts;
  }
}
