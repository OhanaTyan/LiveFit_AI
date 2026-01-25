

class FuzzyInfoHandler {
  // Check for ambiguous information in extracted events
  List<Ambiguity> checkAmbiguities(List<Map<String, dynamic>> extractedEvents) {
    final ambiguities = <Ambiguity>[];
    
    for (int i = 0; i < extractedEvents.length; i++) {
      final event = extractedEvents[i];
      final eventAmbiguities = _checkEventAmbiguities(event, i);
      ambiguities.addAll(eventAmbiguities);
    }
    
    return ambiguities;
  }
  
  // Check for ambiguities in a single event
  List<Ambiguity> _checkEventAmbiguities(Map<String, dynamic> event, int eventIndex) {
    final ambiguities = <Ambiguity>[];
    
    // Check time ambiguity
    if (event['startTime'] == null) {
      ambiguities.add(Ambiguity(
        eventIndex: eventIndex,
        type: AmbiguityType.time,
        field: 'startTime',
        currentValue: null,
        message: '时间信息不明确',
        possibleValues: _generateTimeOptions(),
      ));
    }
    
    // Check location ambiguity
    if (event['location'] == null || event['location'] == '未指定地点') {
      ambiguities.add(Ambiguity(
        eventIndex: eventIndex,
        type: AmbiguityType.location,
        field: 'location',
        currentValue: '未指定地点',
        message: '地点信息不明确',
        possibleValues: ['健身房', '办公室', '家里', '公园', '餐厅'],
      ));
    }
    
    // Check title ambiguity
    if (event['title'] == null || event['title'] == '未命名事件' || event['title'].length < 3) {
      ambiguities.add(Ambiguity(
        eventIndex: eventIndex,
        type: AmbiguityType.title,
        field: 'title',
        currentValue: event['title'] ?? '未命名事件',
        message: '事件标题不明确',
        possibleValues: null, // No predefined values, requires user input
      ));
    }
    
    // Check duration ambiguity
    final startTime = event['startTime'];
    final endTime = event['endTime'];
    if (startTime != null && endTime != null) {
      final duration = endTime.difference(startTime);
      if (duration.inMinutes < 30) {
        ambiguities.add(Ambiguity(
          eventIndex: eventIndex,
          type: AmbiguityType.duration,
          field: 'endTime',
          currentValue: endTime,
          message: '事件持续时间可能过短',
          possibleValues: _generateDurationOptions(startTime),
        ));
      }
    }
    
    return ambiguities;
  }
  
  // Generate possible time options for ambiguous cases
  List<DateTime> _generateTimeOptions() {
    final now = DateTime.now();
    final options = <DateTime>[];
    
    // Generate options for today at common times
    options.add(DateTime(now.year, now.month, now.day, 8, 0));  // Morning
    options.add(DateTime(now.year, now.month, now.day, 12, 0)); // Noon
    options.add(DateTime(now.year, now.month, now.day, 18, 0)); // Evening
    options.add(DateTime(now.year, now.month, now.day, 20, 0)); // Night
    
    // Add tomorrow evening as an option
    options.add(DateTime(now.year, now.month, now.day + 1, 18, 0));
    
    return options;
  }
  
  // Generate possible duration options
  List<DateTime> _generateDurationOptions(DateTime startTime) {
    final options = <DateTime>[];
    
    options.add(startTime.add(const Duration(minutes: 30)));
    options.add(startTime.add(const Duration(hours: 1)));
    options.add(startTime.add(const Duration(hours: 1, minutes: 30)));
    options.add(startTime.add(const Duration(hours: 2)));
    
    return options;
  }
  
  // Resolve an ambiguity by updating the event
  Map<String, dynamic> resolveAmbiguity(
    Map<String, dynamic> event,
    Ambiguity ambiguity,
    dynamic resolvedValue,
  ) {
    final updatedEvent = Map<String, dynamic>.from(event);
    
    switch (ambiguity.type) {
      case AmbiguityType.time:
        if (ambiguity.field == 'startTime') {
          updatedEvent['startTime'] = resolvedValue;
          // Also update end time if it was derived from start time
          if (event['endTime'] != null) {
            final duration = event['endTime'].difference(event['startTime'] ?? DateTime.now());
            updatedEvent['endTime'] = resolvedValue.add(duration);
          } else {
            updatedEvent['endTime'] = resolvedValue.add(const Duration(hours: 1));
          }
        }
        break;
      
      case AmbiguityType.location:
        updatedEvent['location'] = resolvedValue;
        break;
      
      case AmbiguityType.title:
        updatedEvent['title'] = resolvedValue;
        break;
      
      case AmbiguityType.duration:
        if (ambiguity.field == 'endTime') {
          updatedEvent['endTime'] = resolvedValue;
        }
        break;
    }
    
    return updatedEvent;
  }
}

enum AmbiguityType {
  time,
  location,
  title,
  duration,
}

class Ambiguity {
  final int eventIndex;
  final AmbiguityType type;
  final String field;
  final dynamic currentValue;
  final String message;
  final List<dynamic>? possibleValues;
  
  Ambiguity({
    required this.eventIndex,
    required this.type,
    required this.field,
    required this.currentValue,
    required this.message,
    this.possibleValues,
  });
}
