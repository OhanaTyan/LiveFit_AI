import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/domain/onboarding_state.dart';
import '../../features/profile/domain/user_profile.dart';
import '../../features/schedule/domain/models/schedule_event.dart';

class StorageService {
  static StorageService? _instance;
  static late SharedPreferences _prefs;

  // Storage keys
  static const String kOnboardingState = 'onboarding_state';
  static const String kUserProfile = 'user_profile';
  static const String kOnboardingCompleted = 'onboarding_completed';
  static const String kAppVersion = 'app_version';
  static const String kScheduleEvents = 'schedule_events';
  static const String kAISuggestions = 'ai_suggestions';
  static const String kUserPreferences = 'user_preferences';

  factory StorageService() {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  StorageService._internal();

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save onboarding state
  Future<bool> saveOnboardingState(OnboardingState state) async {
    try {
      final json = jsonEncode(state.toJson());
      await _prefs.setString(kOnboardingState, json);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Load onboarding state
  Future<OnboardingState?> loadOnboardingState() async {
    try {
      final jsonString = _prefs.getString(kOnboardingState);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return OnboardingState.fromJson(json);
      }
    } catch (e) {
      // Handle storage error gracefully
      // Return null to indicate failure to load
    }
  return null;
  }

  // Save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final json = jsonEncode(profile.toJson());
      await _prefs.setString(kUserProfile, json);
    } catch (e) {
      // Handle storage error gracefully
      // Operation fails silently to avoid disrupting user experience
    }
  }

  // Load user profile
  Future<UserProfile?> loadUserProfile() async {
    try {
      final jsonString = _prefs.getString(kUserProfile);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return UserProfile.fromJson(json);
      }
    } catch (e) {
      // Handle storage error gracefully
      // Return null to indicate failure to load
    }
    return null;
  }

  // Set onboarding completed
  Future<void> setOnboardingCompleted(bool completed) async {
    try {
      await _prefs.setBool(kOnboardingCompleted, completed);
    } catch (e) {
      // Handle storage error gracefully
      // Operation fails silently to avoid disrupting user experience
    }
  }

  // Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    try {
      return _prefs.getBool(kOnboardingCompleted) ?? false;
    } catch (e) {
      return false;
    }
  }



  // Clear onboarding data
  Future<void> clearOnboardingData() async {
    try {
      await _prefs.remove(kOnboardingState);
      await _prefs.remove(kOnboardingCompleted);
    } catch (e) {
      // Handle storage error gracefully
      // Operation fails silently to avoid disrupting user experience
    }
  }

  // Save schedule events
  Future<bool> saveScheduleEvents(List<ScheduleEvent> events) async {
    try {
      final jsonList = events.map((event) => {
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'startTime': event.startTime.toIso8601String(),
        'endTime': event.endTime.toIso8601String(),
        'type': event.type.toString().split('.').last,
        'color': event.color.toARGB32(),
        'isCompleted': event.isCompleted,
        'priority': event.priority.toString().split('.').last,
        'location': event.location,
        'recurrence': event.recurrence.toString().split('.').last,
        'recurrenceEnd': event.recurrenceEnd?.toIso8601String(),
        'isDeleted': event.isDeleted,
        'deletedAt': event.deletedAt?.toIso8601String(),
        'isStarred': event.isStarred,
      }).toList();
      final json = jsonEncode(jsonList);
      await _prefs.setString(kScheduleEvents, json);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Load schedule events
  Future<List<ScheduleEvent>?> loadScheduleEvents() async {
    try {
      final jsonString = _prefs.getString(kScheduleEvents);
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        final events = jsonList.map((item) {
          final map = item as Map<String, dynamic>;
          return ScheduleEvent(
            id: map['id'] as String,
            title: map['title'] as String,
            description: map['description'] as String,
            startTime: DateTime.parse(map['startTime'] as String),
            endTime: DateTime.parse(map['endTime'] as String),
            type: EventType.values.firstWhere(
              (e) => e.toString().split('.').last == map['type'],
              orElse: () => EventType.life,
            ),
            color: Color(map['color'] as int),
            isCompleted: map['isCompleted'] as bool,
            priority: EventPriority.values.firstWhere(
              (e) => e.toString().split('.').last == (map['priority'] ?? 'medium'),
              orElse: () => EventPriority.medium,
            ),
            location: map['location'] as String?,
            recurrence: RecurrenceType.values.firstWhere(
              (e) => e.toString().split('.').last == (map['recurrence'] ?? 'none'),
              orElse: () => RecurrenceType.none,
            ),
            recurrenceEnd: map['recurrenceEnd'] != null ? DateTime.parse(map['recurrenceEnd'] as String) : null,
            isDeleted: map['isDeleted'] as bool? ?? false,
            deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt'] as String) : null,
            isStarred: map['isStarred'] as bool? ?? false,
          );
        }).toList();
        return events;
      }
    } catch (e) {
      // Handle storage error gracefully
      // Return null to indicate failure to load
    }
    return null;
  }



  // Delete single event (soft delete)
  Future<bool> deleteEvent(String eventId) async {
    try {
      final events = await loadScheduleEvents() ?? [];
      final updatedEvents = events.map((event) {
        if (event.id == eventId) {
          return ScheduleEvent(
            id: event.id,
            title: event.title,
            description: event.description,
            startTime: event.startTime,
            endTime: event.endTime,
            type: event.type,
            color: event.color,
            isCompleted: event.isCompleted,
            priority: event.priority,
            location: event.location,
            recurrence: event.recurrence,
            recurrenceEnd: event.recurrenceEnd,
            isDeleted: true,
            deletedAt: DateTime.now(),
          );
        }
        return event;
      }).toList();
      return await saveScheduleEvents(updatedEvents);
    } catch (e) {
      return false;
    }
  }

  // Batch delete events (soft delete)
  Future<bool> batchDeleteEvents(List<String> eventIds) async {
    try {
      final events = await loadScheduleEvents() ?? [];
      final updatedEvents = events.map((event) {
        if (eventIds.contains(event.id)) {
          return ScheduleEvent(
            id: event.id,
            title: event.title,
            description: event.description,
            startTime: event.startTime,
            endTime: event.endTime,
            type: event.type,
            color: event.color,
            isCompleted: event.isCompleted,
            priority: event.priority,
            location: event.location,
            recurrence: event.recurrence,
            recurrenceEnd: event.recurrenceEnd,
            isDeleted: true,
            deletedAt: DateTime.now(),
          );
        }
        return event;
      }).toList();
      return await saveScheduleEvents(updatedEvents);
    } catch (e) {
      return false;
    }
  }

  // Restore deleted event
  Future<bool> restoreEvent(String eventId) async {
    try {
      final events = await loadScheduleEvents() ?? [];
      final updatedEvents = events.map((event) {
        if (event.id == eventId) {
          return ScheduleEvent(
            id: event.id,
            title: event.title,
            description: event.description,
            startTime: event.startTime,
            endTime: event.endTime,
            type: event.type,
            color: event.color,
            isCompleted: event.isCompleted,
            priority: event.priority,
            location: event.location,
            recurrence: event.recurrence,
            recurrenceEnd: event.recurrenceEnd,
            isDeleted: false,
            deletedAt: null,
          );
        }
        return event;
      }).toList();
      return await saveScheduleEvents(updatedEvents);
    } catch (e) {
      return false;
    }
  }

  // Load only active (not deleted) events
  Future<List<ScheduleEvent>?> loadActiveEvents() async {
    try {
      final events = await loadScheduleEvents() ?? [];
      // Return all events that are not marked as deleted
      return events.where((event) => !event.isDeleted).toList();
    } catch (e) {
      return null;
    }
  }

  // Load only deleted events
  Future<List<ScheduleEvent>?> loadDeletedEvents() async {
    try {
      final events = await loadScheduleEvents() ?? [];
      return events.where((event) => event.isDeleted).toList();
    } catch (e) {
      return null;
    }
  }

  // Clear all storage
  Future<void> clearAll() async {
    try {
      await _prefs.remove(kOnboardingState);
      await _prefs.remove(kUserProfile);
      await _prefs.remove(kOnboardingCompleted);
      await _prefs.remove(kScheduleEvents);
      await _prefs.remove(kAISuggestions);
      await _prefs.remove(kUserPreferences);
    } catch (e) {
      // Handle storage error gracefully
      // Operation fails silently to avoid disrupting user experience
    }
  }
}
