import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/localization/app_localizations.dart';
import 'widgets/setting_item.dart';
import 'widgets/setting_section.dart';
import 'widgets/user_profile_card.dart';
import '../../profile/presentation/profile_edit_screen.dart';
import '../../profile/presentation/pages/aerobic_habits_edit_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppLocalizations.of(context)!.language),
        children: [
          SimpleDialogOption(
            onPressed: () {
              localeProvider.setLocale(const Locale('zh'));
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('中文'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              localeProvider.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('English'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final isLight = theme.brightness == Brightness.light;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isLight ? AppColors.backgroundLight : AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          UserProfileCard(
            onTap: () {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
                );
              } catch (e, stack) {
                debugPrint('${l10n.errorNavigating}: $e');
                debugPrint(stack.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.errorMessage}$e')),
                );
              }
            },
          ),

          SettingSection(
            title: l10n.general,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SettingItem(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.darkMode,
                      iconColor: Colors.purple,
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (val) {
                          themeProvider.toggleTheme(val);
                        },
                        activeTrackColor: AppColors.primary,
                      ),
                      onTap: () {
                        themeProvider.toggleTheme(!isDarkMode);
                      },
                      showArrow: false,
                    ),
                    SettingItem(
                      icon: Icons.language,
                      title: l10n.language,
                      iconColor: Colors.orange,
                      trailing: Row(
                        children: [
                          Text(
                            localeProvider.locale.languageCode == 'zh' ? '中文' : 'English',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                      onTap: () => _showLanguageDialog(context, localeProvider),
                    ),
                    SettingItem(
                      icon: Icons.notifications_outlined,
                      title: l10n.notifications,
                      iconColor: Colors.redAccent,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (val) {
                          setState(() => _notificationsEnabled = val);
                        },
                        activeTrackColor: AppColors.primary,
                      ),
                      onTap: () {},
                      showArrow: false,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SettingSection(
            title: l10n.accountSecurity,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SettingItem(
                      icon: Icons.lock_outline,
                      title: l10n.changePassword,
                      iconColor: Colors.blue,
                      onTap: () => _showSnackBar('Change password feature'),
                    ),
                    SettingItem(
                      icon: Icons.phone_android,
                      title: l10n.bindPhone,
                      iconColor: Colors.teal,
                      trailing: Text(
                        '138****8888',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      onTap: () => _showSnackBar('Bind phone feature'),
                    ),
                  ],
                ),
              ),
            ],
          ),

        // User Habits Section
        SettingSection(
            title: l10n.userHabits,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SettingItem(
                      icon: Icons.directions_run,
                      title: l10n.aerobicExerciseHabits,
                      iconColor: AppColors.primary,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AerobicHabitsEditPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          SettingSection(
            title: l10n.about,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.privacyPolicy,
                      iconColor: Colors.green,
                      onTap: () => _showSnackBar('View privacy policy'),
                    ),
                    SettingItem(
                      icon: Icons.description_outlined,
                      title: l10n.userAgreement,
                      iconColor: Colors.blueGrey,
                      onTap: () => _showSnackBar('View user agreement'),
                    ),
                    SettingItem(
                      icon: Icons.info_outline,
                      title: l10n.aboutUs,
                      iconColor: Colors.indigo,
                      trailing: Text(
                        'v1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () => _showSnackBar('Logout'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.logout,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
