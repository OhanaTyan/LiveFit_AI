import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/event_bus_service.dart';
import '../widgets/energy_battery_header.dart';
import '../widgets/schedule_timeline.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../weather/presentation/widgets/weather_expandable_card.dart';
import '../../../weather/presentation/widgets/exercise_recommendation_card.dart';
import '../../../weather/presentation/widgets/weather_settings_sheet.dart';
import '../../../schedule/domain/models/schedule_event.dart';

import 'package:life_fit/src/features/schedule/presentation/pages/schedule_page.dart';
import '../../../settings/presentation/settings_screen.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _showWeatherSettings = false;
  List<ScheduleEvent> _events = [];
  late PageController _pageController;

  late StreamSubscription<dynamic> _scheduleUpdateSubscription;

  @override
  void initState() {
    super.initState();
    // 初始化PageController
    _pageController = PageController(initialPage: _currentIndex);

    // 天气Provider在main.dart中已初始化，不需要再次初始化

    // 加载日程
    _loadEvents();

    // 监听日程更新事件
    _scheduleUpdateSubscription = EventBusService()
        .onEvent(EventBusService.eventScheduleUpdated)
        .listen((event) {
          _handleScheduleUpdated();
        });
  }

  @override
  void dispose() {
    _scheduleUpdateSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleScheduleUpdated() async {
    await _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final storageService = StorageService();
      final events = await storageService.loadActiveEvents();
      setState(() {
        _events = events ?? [];
      });
    } catch (e) {
      // 出错时返回空列表，不显示默认日程
      setState(() {
        _events = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10nNullable = AppLocalizations.of(context);
    if (l10nNullable == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final l10n = l10nNullable;
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // 禁用PageView的滑动功能，只允许通过底部导航栏切换页面
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Home Dashboard
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const EnergyBatteryHeader(energyLevel: 0.75),
                  const SizedBox(height: 16),
                  // 天气模块 - 可展开卡片
                  WeatherExpandableCard(
                    weatherProvider: weatherProvider,
                    onRefresh: () => weatherProvider.fetchWeatherData(),
                    onLocationChange: () {
                      // 实现位置切换逻辑
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.positionSwitchInDevelopment),
                        ),
                      );
                    },
                    onSettingsTap: () {
                      setState(() {
                        _showWeatherSettings = true;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // 运动建议卡片
                  ExerciseRecommendationCard(weatherProvider: weatherProvider),
                  const SizedBox(height: 24),
                  // 今日日程模块
                  ScheduleTimeline(events: _events),
                  const SizedBox(height: 32), // 增加底部边距，确保内容不被导航栏遮挡
                ],
              ),
            ),
          ),
          // Schedule Page
          const SchedulePage(),
          // Statistics Page
          const StatisticsPage(),
          // Settings / Profile Page
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withValues(alpha: 0.2),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(
                Icons.dashboard,
                color: AppColors.primary,
              ),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(
                Icons.calendar_month,
                color: AppColors.primary,
              ),
              label: l10n.navSchedule,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(
                Icons.bar_chart,
                color: AppColors.primary,
              ),
              label: l10n.statistics,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person, color: AppColors.primary),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
      // 天气设置底部表单
      bottomSheet: _showWeatherSettings
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: WeatherSettingsSheet(
                weatherProvider: weatherProvider,
                onClose: () {
                  setState(() {
                    _showWeatherSettings = false;
                  });
                },
              ),
            )
          : null,
    );
  }
}
