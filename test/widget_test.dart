// This is a basic Flutter widget test for LifeFit AI app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:life_fit/src/core/theme/theme_provider.dart';
import 'package:life_fit/src/core/localization/locale_provider.dart';
import 'package:life_fit/src/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:life_fit/src/features/weather/presentation/providers/weather_provider.dart';

import 'package:life_fit/main.dart';

void main() {
  testWidgets('App should start with MultiProvider setup', (WidgetTester tester) async {
    // Build our app with proper MultiProvider setup as in main.dart
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ],
        child: const LifeFitApp(),
      ),
    );

    // Only pump once to get initial frame, don't wait for async operations
    await tester.pump();

    // Verify that our app starts with MultiProvider and no ProviderNotFoundException
    // We can't check for splash screen text because navigation happens asynchronously
    // Just verify that the widget tree builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
