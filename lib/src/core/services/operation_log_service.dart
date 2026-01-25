import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OperationLog {
  final String id;
  final String userId;
  final String username;
  final DateTime timestamp;
  final String operationType;
  final List<String> affectedIds;
  final int affectedCount;
  final String operationMode;
  final String ipAddress;
  final bool success;

  OperationLog({
    required this.id,
    required this.userId,
    required this.username,
    required this.timestamp,
    required this.operationType,
    required this.affectedIds,
    required this.affectedCount,
    required this.operationMode,
    required this.ipAddress,
    required this.success,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'timestamp': timestamp.toIso8601String(),
      'operationType': operationType,
      'affectedIds': affectedIds,
      'affectedCount': affectedCount,
      'operationMode': operationMode,
      'ipAddress': ipAddress,
      'success': success,
    };
  }

  factory OperationLog.fromJson(Map<String, dynamic> json) {
    return OperationLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      operationType: json['operationType'] as String,
      affectedIds: List<String>.from(json['affectedIds'] as List),
      affectedCount: json['affectedCount'] as int,
      operationMode: json['operationMode'] as String,
      ipAddress: json['ipAddress'] as String,
      success: json['success'] as bool,
    );
  }
}

class OperationLogService {
  static OperationLogService? _instance;
  static late SharedPreferences _prefs;

  // Storage keys
  static const String kOperationLogs = 'operation_logs';
  static const int kLogRetentionDays = 365; // 1 year retention

  factory OperationLogService() {
    _instance ??= OperationLogService._internal();
    return _instance!;
  }

  OperationLogService._internal();

  // Initialize SharedPreferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generate a unique ID for log entries
  String _generateLogId() {
    return 'log_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  // Get IP address (simplified for demo, in real app use a proper IP service)
  Future<String> _getIpAddress() async {
    try {
      // For demo purposes, return a placeholder IP
      return '127.0.0.1';
    } catch (e) {
      return 'unknown';
    }
  }

  // Log an operation
  Future<void> logOperation({
    required String userId,
    required String username,
    required String operationType,
    required List<String> affectedIds,
    required String operationMode,
    required bool success,
  }) async {
    try {
      final logId = _generateLogId();
      final timestamp = DateTime.now();
      final ipAddress = await _getIpAddress();

      final log = OperationLog(
        id: logId,
        userId: userId,
        username: username,
        timestamp: timestamp,
        operationType: operationType,
        affectedIds: affectedIds,
        affectedCount: affectedIds.length,
        operationMode: operationMode,
        ipAddress: ipAddress,
        success: success,
      );

      // Load existing logs
      final logs = await getLogs();
      logs.add(log);

      // Remove old logs that exceed retention period
      final retentionDate = DateTime.now().subtract(const Duration(days: kLogRetentionDays));
      final filteredLogs = logs.where((log) => log.timestamp.isAfter(retentionDate)).toList();

      // Save filtered logs back to storage
      final jsonList = filteredLogs.map((log) => log.toJson()).toList();
      final json = jsonEncode(jsonList);
      await _prefs.setString(kOperationLogs, json);
    } catch (e) {
      // Handle storage error gracefully
      // In real app, consider logging to a server or file
    }
  }

  // Get all logs
  Future<List<OperationLog>> getLogs() async {
    try {
      final jsonString = _prefs.getString(kOperationLogs);
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList.map((item) => OperationLog.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Handle storage error gracefully
    }
    return [];
  }

  // Get logs by user ID
  Future<List<OperationLog>> getLogsByUserId(String userId) async {
    final logs = await getLogs();
    return logs.where((log) => log.userId == userId).toList();
  }

  // Get logs by time range
  Future<List<OperationLog>> getLogsByTimeRange(DateTime start, DateTime end) async {
    final logs = await getLogs();
    return logs.where((log) => log.timestamp.isAfter(start) && log.timestamp.isBefore(end)).toList();
  }

  // Get logs by operation type
  Future<List<OperationLog>> getLogsByOperationType(String operationType) async {
    final logs = await getLogs();
    return logs.where((log) => log.operationType == operationType).toList();
  }

  // Clear all logs
  Future<void> clearAllLogs() async {
    try {
      await _prefs.remove(kOperationLogs);
    } catch (e) {
      // Handle storage error gracefully
    }
  }
}

// Add Random import to make _generateLogId work
class Random {
  int nextInt(int max) {
    return DateTime.now().millisecondsSinceEpoch % max;
  }
}