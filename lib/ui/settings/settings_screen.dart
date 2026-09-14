import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/activity/activity_bloc.dart';
import '../../bloc/activity/activity_event.dart';
import '../../bloc/concurrent/concurrent_cubit.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../../core/constants/colors.dart';
import '../../core/dependency/injection.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/services/notification_service.dart';
import '../../core/util/log_util.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'vi': 'Tiếng Việt',
  };
  static const Map<String, String> _supportedCurrencies = {
    'en': 'USD',
    'vi': 'VND',
  };

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDailyReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  void _loadNotificationSetting() {
    final prefs = getIt<SharedPreferences>();
    setState(() {
      _isDailyReminderEnabled = prefs.getBool('daily_reminder_enabled') ?? false;
    });
  }

  Future<void> _toggleDailyReminder(bool enabled) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setBool('daily_reminder_enabled', enabled);
    setState(() {
      _isDailyReminderEnabled = enabled;
    });

    if (enabled) {
      await NotificationService.instance.requestPermissions();
      await NotificationService.instance.scheduleDailyReminder(hour: 20, minute: 0);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.dailyReminderEnabledMsg),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      await NotificationService.instance.cancelDailyReminder();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.dailyReminderDisabledMsg),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.background;
    final Color cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color borderColor = isDark ? AppColors.darkOutline : AppColors.outline;
    final Color itemTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final Color secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color arrowColor = secondaryTextColor;

    final currentThemeMode = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;
    final currentCurrency = context.watch<CurrencyCubit>().state;
    final isDarkModeOn = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
          style: TextStyle(
            color: itemTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preference Section
            _buildSectionHeader(context, "Preferences", itemTextColor),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  // Dark Mode Setting
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.dark_mode_outlined,
                    iconColor: AppColors.primary,
                    title: S.of(context).darkMode,
                    textColor: itemTextColor,
                    trailing: Switch(
                      value: isDarkModeOn,
                      activeThumbColor: AppColors.primary,
                      onChanged: (bool value) {
                        final newMode = value ? ThemeMode.dark : ThemeMode.light;
                        context.read<ThemeCubit>().setTheme(newMode);
                      },
                    ),
                  ),
                  _buildDivider(borderColor),

                  // Daily Reminder Setting
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.notifications_active_outlined,
                    iconColor: AppColors.accent,
                    title: S.of(context).dailyReminder,
                    subtitle: S.of(context).dailyReminderDesc,
                    textColor: itemTextColor,
                    trailing: Switch(
                      value: _isDailyReminderEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: _toggleDailyReminder,
                    ),
                  ),
                  _buildDivider(borderColor),

                  // Language Setting
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.language_outlined,
                    iconColor: AppColors.income,
                    title: S.of(context).language,
                    textColor: itemTextColor,
                    trailing: DropdownButton<String>(
                      value: currentLocale.languageCode,
                      underline: const SizedBox.shrink(),
                      dropdownColor: cardColor,
                      icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
                      isDense: true,
                      items: SettingsScreen._supportedLanguages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: TextStyle(color: itemTextColor, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newLanguageCode) {
                        if (newLanguageCode != null &&
                            newLanguageCode != currentLocale.languageCode) {
                          context.read<LocaleCubit>().setLocale(Locale(newLanguageCode));
                        }
                      },
                    ),
                  ),
                  _buildDivider(borderColor),

                  // Currency Setting
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.monetization_on_outlined,
                    iconColor: AppColors.accent,
                    title: S.of(context).currency,
                    textColor: itemTextColor,
                    trailing: DropdownButton<String>(
                      value: currentCurrency.languageCode,
                      underline: const SizedBox.shrink(),
                      dropdownColor: cardColor,
                      icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
                      isDense: true,
                      items: SettingsScreen._supportedCurrencies.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: TextStyle(color: itemTextColor, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newLanguageCode) {
                        if (newLanguageCode != null &&
                            newLanguageCode != currentCurrency.languageCode) {
                          context.read<CurrencyCubit>().setLocale(Locale(newLanguageCode));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Data & Storage Section
            _buildSectionHeader(context, "Data & System", itemTextColor),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.cleaning_services_outlined,
                    iconColor: AppColors.expense,
                    title: S.of(context).clearCache,
                    textColor: itemTextColor,
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: arrowColor),
                    onTap: () async => _confirmAndClearCache(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Information & Policy Section
            _buildSectionHeader(context, S.of(context).aboutApp, itemTextColor),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.privacy_tip_outlined,
                    iconColor: AppColors.primary,
                    title: S.of(context).privacyPolicy,
                    subtitle: S.of(context).privacyPolicyDesc,
                    textColor: itemTextColor,
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: arrowColor),
                    onTap: () => _showPolicyDialog(context, S.of(context).privacyPolicy),
                  ),
                  _buildDivider(borderColor),
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.description_outlined,
                    iconColor: AppColors.secondary,
                    title: S.of(context).termsOfService,
                    textColor: itemTextColor,
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: arrowColor),
                    onTap: () => _showPolicyDialog(context, S.of(context).termsOfService),
                  ),
                  _buildDivider(borderColor),
                  _buildSettingsTile(
                    context: context,
                    icon: Icons.info_outline,
                    iconColor: secondaryTextColor,
                    title: S.of(context).appVersion,
                    textColor: itemTextColor,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "v1.0.1 (Nordic 2.0)",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndClearCache(BuildContext context) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(ctx).confirmClearCacheTitle),
        content: Text(S.of(ctx).confirmClearCacheContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(S.of(ctx).cancelButton),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(S.of(ctx).clearButton),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        context.read<ActivityBloc>().add(const ClearAllActivities());
        await HydratedBloc.storage.clear();
        LogUtil.i("HydratedBloc storage cleared.");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).cacheClearedSuccess),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        LogUtil.e("Error clearing cache: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).cacheClearError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showPolicyDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            "Manage Salary is committed to protecting your privacy.\n\n"
            "1. Data Privacy: All your salary, attendance, and expense records are stored strictly offline on your local device.\n\n"
            "2. No Tracking: We do not upload your personal financial data to any external server.\n\n"
            "3. Multi-Currency: Historical activities store their transaction currency code locally to guarantee consistent audit records.\n\n"
            "Version: 1.0.1+10 (Nordic Minimalist)",
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      dense: true,
    );
  }

  Widget _buildDivider(Color borderColor) {
    return Divider(
      height: 1,
      thickness: 0.8,
      indent: 56,
      endIndent: 16,
      color: borderColor.withValues(alpha: 0.7),
    );
  }
}
