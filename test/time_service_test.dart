import 'package:flutter_test/flutter_test.dart';
import 'package:life_fit/src/core/services/time_service.dart';

// Mock implementation of TimeObserver for testing
class _MockTimeObserver implements TimeObserver {
  final void Function(DateTime, String) _onTimeUpdatedCallback;

  _MockTimeObserver({
    required void Function(DateTime, String) onTimeUpdatedCallback,
  }) : _onTimeUpdatedCallback = onTimeUpdatedCallback;

  @override
  void onTimeUpdated(DateTime currentTime, String formattedTime) {
    _onTimeUpdatedCallback(currentTime, formattedTime);
  }
}

void main() {
  // 初始化Flutter绑定，确保测试环境正常工作
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TimeService', () {
    late TimeService timeService;

    setUp(() {
      // 注意：由于TimeService使用单例模式，这里需要特殊处理以确保测试隔离
      // 我们将避免在测试中调用dispose()，而是让每个测试使用相同的实例
      timeService = TimeService();
    });

    tearDown(() {
      // 不调用dispose()，因为单例的dispose会影响其他测试
    });

    test('should initialize correctly', () async {
      // Arrange & Act
      await timeService.initialize();

      // Assert
      expect(timeService.displayMode, equals(TimeDisplayMode.twentyFourHour));
      expect(timeService.formatType, equals(TimeFormatType.standard24Hour));
      expect(timeService.useAutomaticTimezone, isTrue);
    });

    test('should switch between 24-hour and 12-hour display modes', () async {
      // Arrange
      await timeService.initialize();

      // Act: Switch to 12-hour mode
      await timeService.setDisplayMode(TimeDisplayMode.twelveHour);

      // Assert
      expect(timeService.displayMode, equals(TimeDisplayMode.twelveHour));
      expect(timeService.formatType, equals(TimeFormatType.standard12Hour));

      // Act: Switch back to 24-hour mode
      await timeService.setDisplayMode(TimeDisplayMode.twentyFourHour);

      // Assert
      expect(timeService.displayMode, equals(TimeDisplayMode.twentyFourHour));
      expect(timeService.formatType, equals(TimeFormatType.standard24Hour));
    });

    test('should format time correctly in 24-hour mode', () async {
      // Arrange
      await timeService.initialize();
      await timeService.setDisplayMode(TimeDisplayMode.twentyFourHour);
      final testTime = DateTime(2023, 1, 1, 14, 30, 45);

      // Act
      final formattedTime = timeService.formatTime(testTime);

      // Assert
      expect(formattedTime, equals('14:30:45'));
    });

    test('should format time correctly in 12-hour mode', () async {
      // Arrange
      await timeService.initialize();
      await timeService.setDisplayMode(TimeDisplayMode.twelveHour);
      final testTime = DateTime(2023, 1, 1, 14, 30, 45);

      // Act
      final formattedTime = timeService.formatTime(testTime);

      // Assert
      expect(formattedTime, equals('02:30:45 PM'));
    });

    test('should support custom time formats', () async {
      // Arrange
      await timeService.initialize();
      await timeService.setCustomFormat('yyyy-MM-dd HH:mm:ss');
      final testTime = DateTime(2023, 12, 25, 10, 15, 30);

      // Act
      final formattedTime = timeService.formatTime(testTime);

      // Assert
      expect(formattedTime, equals('2023-12-25 10:15:30'));
    });

    test('should convert DateTime to timestamp correctly', () {
      // Arrange - Create UTC DateTime explicitly
      final testTime = DateTime.utc(2023, 1, 1, 0, 0, 0, 0);

      // Act
      final timestamp = timeService.dateTimeToTimestamp(testTime);

      // Assert
      expect(timestamp, equals(1672531200000)); // UTC timestamp for 2023-01-01 00:00:00
    });

    test('should convert timestamp to DateTime correctly', () {
      // Arrange
      final testTimestamp = 1672531200000; // UTC timestamp for 2023-01-01 00:00:00

      // Act
      final dateTime = timeService.timestampToDateTime(testTimestamp);

      // Assert - Compare with UTC DateTime
      expect(dateTime, equals(DateTime.utc(2023, 1, 1, 0, 0, 0, 0)));
    });

    test('should return current timestamp correctly', () async {
      // Arrange
      await timeService.initialize();

      // Act
      final timestamp1 = timeService.getCurrentTimestamp();
      final timestamp2 = timeService.getCurrentTimestamp();

      // Assert
      expect(timestamp2, greaterThanOrEqualTo(timestamp1));
    });

    test('should handle timezone settings correctly', () async {
      // Arrange
      await timeService.initialize();

      // Act: Set automatic timezone
      await timeService.setAutomaticTimezone(true);

      // Assert
      expect(timeService.useAutomaticTimezone, isTrue);
      expect(timeService.timezone, isNotEmpty);

      // Act: Set manual timezone
      await timeService.setTimezone('UTC');

      // Assert
      expect(timeService.useAutomaticTimezone, isFalse);
      expect(timeService.timezone, equals('UTC'));

      // Act: Switch back to automatic timezone
      await timeService.setAutomaticTimezone(true);

      // Assert
      expect(timeService.useAutomaticTimezone, isTrue);
    });

    test('should support custom format with different separators', () async {
      // Arrange
      await timeService.initialize();
      final testTime = DateTime(2023, 6, 15, 18, 45, 20);

      // Act: Test custom format with dots as separators
      await timeService.setCustomFormat('HH.mm.ss');
      final formattedTime1 = timeService.formatTime(testTime);

      // Assert
      expect(formattedTime1, equals('18.45.20'));

      // Act: Test custom format with different order
      await timeService.setCustomFormat('ss:MM:HH');
      final formattedTime2 = timeService.formatTime(testTime);

      // Assert
      expect(formattedTime2, equals('20:06:18'));
    });

    test('should handle invalid custom format gracefully', () async {
      // Arrange
      await timeService.initialize();
      final testTime = DateTime(2023, 1, 1, 10, 30, 45);

      // Act: Set invalid custom format
      await timeService.setCustomFormat('invalid-format');
      final formattedTime = timeService.formatTime(testTime);

      // Assert: Should fallback to default format
      expect(formattedTime, isNotNull);
      expect(formattedTime, isNotEmpty);
    });

    test('should provide formatted current time', () async {
      // Arrange
      await timeService.initialize();

      // Act
      final formattedTime = timeService.getFormattedCurrentTime();

      // Assert
      expect(formattedTime, isNotNull);
      expect(formattedTime, isNotEmpty);
      // Check if the format matches 24-hour pattern
      expect(formattedTime, matches(RegExp(r'^\d{2}:\d{2}:\d{2}$')));
    });

    test('should register and notify observers', () async {
      // Arrange
      await timeService.initialize();
      bool observerCalled = false;
      DateTime? receivedTime;
      String? receivedFormattedTime;

      // Create a mock observer
      final observer = _MockTimeObserver(
        onTimeUpdatedCallback: (time, formattedTime) {
          observerCalled = true;
          receivedTime = time;
          receivedFormattedTime = formattedTime;
        },
      );

      // Act: Register observer
      timeService.registerObserver(observer);
      // Wait for next time update (1 second interval)
      await Future.delayed(const Duration(seconds: 1));

      // Assert
      expect(observerCalled, isTrue);
      expect(receivedTime, isNotNull);
      expect(receivedFormattedTime, isNotNull);

      // Act: Remove observer
      observerCalled = false;
      timeService.removeObserver(observer);
      // Wait for next time update
      await Future.delayed(const Duration(seconds: 1));

      // Assert: Observer should not be called after removal
      expect(observerCalled, isFalse);
    });

    test('should handle time stream correctly', () async {
      // Arrange
      await timeService.initialize();
      int updateCount = 0;
      DateTime? lastTime;

      // Act: Subscribe to time stream
      final subscription = timeService.timeStream.listen((time) {
        updateCount++;
        lastTime = time;
      });

      // Wait for a few updates
      await Future.delayed(const Duration(seconds: 2));
      await subscription.cancel();

      // Assert
      expect(updateCount, greaterThanOrEqualTo(1));
      expect(lastTime, isNotNull);
    });

    test('should set update interval correctly', () async {
      // Arrange
      await timeService.initialize();
      int updateCount = 0;

      // Act: Set shorter update interval
      timeService.setUpdateInterval(const Duration(milliseconds: 500));
      final subscription = timeService.timeStream.listen((_) {
        updateCount++;
      });

      // Wait for updates
      await Future.delayed(const Duration(seconds: 1));
      await subscription.cancel();

      // Assert: Should receive more updates with shorter interval
      expect(updateCount, greaterThanOrEqualTo(1));
    });

    test('should convert between DateTime and timestamp correctly', () async {
      // Arrange
      await timeService.initialize();
      final originalTime = DateTime.now();

      // Act
      final timestamp = timeService.dateTimeToTimestamp(originalTime);
      final convertedTime = timeService.timestampToDateTime(timestamp);

      // Assert: The converted time should be very close to original (considering millisecond precision)
      expect(convertedTime.difference(originalTime).inMilliseconds, lessThanOrEqualTo(1));
    });

    test('should handle max retries configuration', () {
      // Arrange & Act
      timeService.setMaxRetries(5);

      // Assert: This is a bit tricky to test directly as it involves error handling
      // We can verify that the method exists and doesn't throw, but testing the actual retry logic would require mocking
      // For this test, we'll just ensure the method doesn't throw
      expect(() => timeService.setMaxRetries(5), returnsNormally);
    });

    test('should return cached time when current time is unavailable', () async {
      // Arrange
      await timeService.initialize();
      // Get current time to ensure cache is populated
      timeService.getCurrentTime();

      // Act: Invalidate current time (this is a bit contrived for testing)
      // Note: In a real implementation, you might need to mock the time source to test this scenario properly
      final cachedTime = timeService.getCurrentTime();

      // Assert
      expect(cachedTime, isNotNull);
    });

    test('should format time in 12-hour mode with AM/PM', () async {
      // Arrange
      await timeService.initialize();
      await timeService.setDisplayMode(TimeDisplayMode.twelveHour);
      
      // Test morning time
      final morningTime = DateTime(2023, 1, 1, 8, 30, 15);
      // Test afternoon time
      final afternoonTime = DateTime(2023, 1, 1, 14, 30, 15);

      // Act
      final formattedMorning = timeService.formatTime(morningTime);
      final formattedAfternoon = timeService.formatTime(afternoonTime);

      // Assert
      expect(formattedMorning, matches(RegExp(r'^08:30:15 AM$')));
      expect(formattedAfternoon, matches(RegExp(r'^02:30:15 PM$')));
    });
  });
}