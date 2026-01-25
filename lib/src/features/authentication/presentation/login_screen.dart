import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import 'widgets/privacy_agreement_row.dart';
import '../../onboarding/presentation/screens/onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _agreedToPrivacy = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleLogin(String method) {
    final l10nNullable = AppLocalizations.of(context);
    if (l10nNullable == null) return;
    final l10n = l10nNullable;
    
    if (!_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.agreeToPrivacy),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Mock Login Success -> Navigate to Onboarding
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  void _showProtocol(String title) {
    final l10nNullable = AppLocalizations.of(context);
    if (l10nNullable == null) return;
    final l10n = l10nNullable;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(l10n.sampleProtocol),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.iUnderstand),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10nNullable = AppLocalizations.of(context);
    if (l10nNullable == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final l10n = l10nNullable;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Animated Mesh Background
          _buildAnimatedBackground(isDark),

          // 2. Glass Overlay & Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Logo Section
                _buildLogoSection(theme),
                const Spacer(flex: 3),
                
                // Bottom Sheet Form
                _buildLoginForm(theme, isDark, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Stack(
          children: [
            // 渐变背景
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: GradientColors.background,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // 浮动渐变 blob 1
            Positioned(
              top: -100 + (_animController.value * 50),
              left: -50 + (_animController.value * 30),
              child: _buildGradientBlob(GradientColors.primary, 300),
            ),
            // 浮动渐变 blob 2
            Positioned(
              bottom: 200 - (_animController.value * 50),
              right: -100 - (_animController.value * 30),
              child: _buildGradientBlob(GradientColors.secondary, 350),
            ),
            // 模糊效果
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ],
        );
      },
    );
  }
  
  // 渐变 blob 构建器
  Widget _buildGradientBlob(List<Color> colors, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colors[0].withValues(alpha: 0.3),
            colors[1].withValues(alpha: 0.1),
            Colors.transparent,
          ],
          center: Alignment.center,
          radius: 0.8,
        ),
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: GradientColors.primary,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: GradientColors.primary[0].withValues(alpha: 0.4),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.fitness_center, size: 52, color: Colors.white),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'LifeFit AI',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: GradientColors.primary,
              ).createShader(const Rect.fromLTWH(0, 0, 220, 70)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Vitality Stream',
          style: theme.textTheme.bodyLarge?.copyWith(
            letterSpacing: 5,
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme, bool isDark, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E).withValues(alpha: 0.9) : AppColors.surfaceLight.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.loginTitle,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          
          // Social Login Buttons - Long Rounded Rectangles
          Column(
            children: [
              _buildSocialButton(
                icon: Icons.chat,
                color: AppColors.wechat,
                label: l10n.wechatLogin,
                onTap: () => _handleLogin('WeChat'),
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                icon: Icons.account_circle,
                color: AppColors.qq,
                label: l10n.qqLogin,
                onTap: () => _handleLogin('QQ'),
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                icon: Icons.apple,
                color: isDark ? AppColors.modernBlue.primary : AppColors.modernBlue.primary,
                label: l10n.appleLogin,
                onTap: () => _handleLogin('Apple'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Privacy - Moved below login buttons
          PrivacyAgreementRow(
            value: _agreedToPrivacy,
            onChanged: (val) => setState(() => _agreedToPrivacy = val ?? false),
            onProtocolTap: () => _showProtocol(l10n.userAgreement),
            onPrivacyTap: () => _showProtocol(l10n.privacyPolicy),
          ),
          
          const SizedBox(height: 24),
          // Visitor Entry
          TextButton(
            onPressed: () => _handleLogin('Guest'),
            child: Text(
              l10n.exploreAsGuest,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
