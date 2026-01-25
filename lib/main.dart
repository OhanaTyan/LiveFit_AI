/// LifeFit AI - 日程驱动的智能健身助手
/// 应用入口文件
///
/// 相关文档：
/// - 项目架构设计：docs/core/architecture_design.md
/// - 技术文档：docs/core/technical_architecture.md
/// - 项目结构：docs/core/project_structure.md
/// - 开发环境配置：docs/development/开发环境配置.md
///
/// 核心功能：
/// - 用户认证与登录
/// - 仪表盘与日程管理
/// - AI智能建议
/// - 天气集成
/// - 主题与国际化支持
///
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_provider.dart';
import 'src/core/localization/locale_provider.dart';
import 'src/core/localization/app_localizations.dart';
import 'src/core/services/storage_service.dart';
import 'src/core/services/time_service.dart';
import 'src/core/utils/env_utils.dart';
import 'src/core/services/log_service.dart';
import 'src/features/authentication/presentation/login_screen.dart';
import 'src/features/dashboard/presentation/pages/dashboard_page.dart';
import 'src/features/profile/presentation/providers/user_profile_provider.dart';
import 'src/features/weather/presentation/providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting();

    // Initialize environment variables
    await EnvUtils.initialize();

    // Initialize storage service
    await StorageService.initialize();

    // Initialize time service
    await TimeService().initialize();
  } catch (e, stackTrace) {
    log.error('初始化应用程序时出错: $e $stackTrace');
    // 即使初始化失败，也继续运行应用程序
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final weatherProvider = WeatherProvider();
            // Initialize weather provider after creation
            try {
              weatherProvider.initialize();
            } catch (e, stackTrace) {
              log.error('初始化天气提供者时出错: $e $stackTrace');
            }
            return weatherProvider;
          },
        ),
      ],
      child: const LifeFitApp(),
    ),
  );
}

class LifeFitApp extends StatelessWidget {
  const LifeFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'LifeFit AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          supportedLocales: const [Locale('en'), Locale('zh')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const _StartupScreen(),
        );
      },
    );
  }
}

class _StartupScreen extends StatefulWidget {
  const _StartupScreen();

  @override
  State<_StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<_StartupScreen> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkStartupState();
  }

  Future<void> _checkStartupState() async {
    try {
      // Check if user profile exists
      final userProfile = await _storageService.loadUserProfile();
      if (!mounted) return;

      if (userProfile != null) {
        // User profile exists, go to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        // No user profile, go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      // Default to login screen on error
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple splash screen
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LifeFit AI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
