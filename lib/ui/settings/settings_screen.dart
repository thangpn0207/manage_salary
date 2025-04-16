// presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; // For clearing storage
import 'package:manage_salary/bloc/activity/activity_bloc.dart';
import 'package:manage_salary/bloc/activity/activity_event.dart';
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/bloc/theme/cubit/theme_cubit.dart';

import '../../core/constants/colors.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/util/log_util.dart'; // Import generated localization

class SettingsScreen extends StatelessWidget {
  // Changed to StatelessWidget
  const SettingsScreen({super.key});

  // Language map (can be moved to a constants file)
  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'vi': 'Vietnamese', // TODO: Consider localizing language names themselves?
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Colors defined based on theme (no change needed here)
    final Color backgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey[900]!
        : AppColors.primary;
    final Color cardColor = theme.brightness == Brightness.dark
        ? Colors.grey[850]!
        : const Color(0xFFF5F5F5);
    final Color titleColor = Colors.white;
    final Color itemTextColor = theme.colorScheme.onSurface;
    final Color arrowColor = theme.hintColor;

    // Get current state from Blocs using context.watch
    final currentThemeMode = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;

    final isDarkModeOn = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).settings, // Use localization
            style: TextStyle(
                color: titleColor, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: titleColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Dark Mode Setting ---
              _buildSettingsTile(
                context: context,
                title: S.of(context).darkMode, // Use localization
                textColor: itemTextColor,
                trailing: Switch(
                  value: isDarkModeOn, // Use calculated value
                  onChanged: (bool value) {
                    final newMode = value ? ThemeMode.dark : ThemeMode.light;
                    context.read<ThemeCubit>().setTheme(newMode);
                  },
                ),
              ),

              _buildDivider(),

              // --- Language Setting ---
              _buildSettingsTile(
                context: context,
                title: S.of(context).language, // Use localization
                textColor: itemTextColor,
                trailing: DropdownButton<String>(
                  value: currentLocale.languageCode,
                  underline: Container(height: 0),
                  icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
                  isDense: true,
                  items: _supportedLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value, // Language names are still hardcoded
                        style: TextStyle(color: itemTextColor, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newLanguageCode) {
                    if (newLanguageCode != null &&
                        newLanguageCode != currentLocale.languageCode) {
                      context
                          .read<LocaleCubit>()
                          .setLocale(Locale(newLanguageCode));
                    }
                  },
                ),
              ),

              _buildDivider(),

              // --- Clear Cache Setting ---
              _buildSettingsTile(
                context: context,
                title: S.of(context).clearCache,
                // Use localization
                textColor: itemTextColor,
                trailing:
                    Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
                onTap: () async =>
                    _confirmAndClearCache(context), // Extract logic
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted function for clearing cache logic
  Future<void> _confirmAndClearCache(BuildContext context) async {
    bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(S.of(ctx).confirmClearCacheTitle), // Use localization
              content:
                  Text(S.of(ctx).confirmClearCacheContent), // Use localization
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: Text(S.of(ctx).cancelButton)), // Use localization
                TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text(S.of(ctx).clearButton)), // Use localization
              ],
            ));

    if (confirmed == true && context.mounted) {
      // Check context is still valid
      try {
        context.read<ActivityBloc>().add(ClearAllActivities()); // Reset locale
        await HydratedBloc.storage.clear();
        LogUtil.i("HydratedBloc storage cleared.");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(S.of(context).cacheClearedSuccess), // Use localization
                duration: Duration(seconds: 2)),
          );
          // Optional: Reset relevant Blocs if needed after clearing
        }
      } catch (e) {
        LogUtil.e("Error clearing cache: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(S.of(context).cacheClearError), // Use localization
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Helper widget to build consistent ListTiles
  Widget _buildSettingsTile({
    required BuildContext context,
    required String title,
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      dense: true,
    );
  }

  // Helper for the divider
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
