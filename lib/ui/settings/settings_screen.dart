// presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; // For clearing storage
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/bloc/theme/cubit/theme_cubit.dart';

import '../../core/constants/colors.dart';
import '../../core/locale/generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  // Changed to StatelessWidget
  const SettingsScreen({super.key});

  // Language map (can be moved to a constants file)
  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'vi': 'Vietnamese',
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
    // Use watch so UI rebuilds when state changes
    final currentThemeMode = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;

    // Determine switch state based on ThemeMode
    // For simplicity, switch toggles between light/dark explicitly
    // System setting is handled by initial state / user choice elsewhere
    final isDarkModeOn = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(S.current.settings,
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
                title: S.current.darkMode, // TODO: Localize this string
                textColor: itemTextColor,
                trailing: Switch(
                  value: isDarkModeOn, // Use calculated value
                  onChanged: (bool value) {
                    // Dispatch event to ThemeBloc
                    final newMode = value ? ThemeMode.dark : ThemeMode.light;
                    context.read<ThemeCubit>().setTheme(newMode);
                  },
                ),
              ),

              _buildDivider(),

              // --- Language Setting ---
              _buildSettingsTile(
                context: context,
                title: S.current.language, // TODO: Localize this string
                textColor: itemTextColor,
                trailing: DropdownButton<String>(
                  value: currentLocale.languageCode,
                  // Use language code from LocaleBloc
                  underline: Container(height: 0),
                  icon: Icon(Icons.keyboard_arrow_down, color: arrowColor),
                  isDense: true,
                  items: _supportedLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        style: TextStyle(color: itemTextColor, fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newLanguageCode) {
                    if (newLanguageCode != null &&
                        newLanguageCode != currentLocale.languageCode) {
                      // Dispatch event to LocaleBloc
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
                title: S.current.clearCache,
                // TODO: Localize this string
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
              // TODO: Localize Dialog text
              title: const Text("Confirm Clear Cache"),
              content: const Text(
                  "Are you sure? This will remove all stored activity data and might reset preferences."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text("Cancel")),
                TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text("Clear")),
              ],
            ));

    if (confirmed == true && context.mounted) {
      // Check context is still valid
      try {
        // Option 1: Clear specific Bloc storage (if ActivityBloc is Hydrated)
        // This requires ActivityBloc to be accessible here
        // await HydratedBloc.storage.delete('ActivityBloc'); // Requires knowing the key

        // Option 2: Clear ALL HydratedBloc storage (use with caution!)
        await HydratedBloc.storage.clear();
        print("HydratedBloc storage cleared.");

        // Option 3: Dispatch a specific event to relevant Blocs
        // context.read<ActivityBloc>().add(ClearAllActivities()); // If you implement this event
        // context.read<ThemeBloc>().add(ResetThemeToDefault()); // If needed
        // context.read<LocaleBloc>().add(ResetLocaleToDefault()); // If needed

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Cache Cleared Successfully."),
              duration: Duration(seconds: 2)),
        );

        // Optional: You might want to force a reload or reset of some states
        // For example, reload the activity bloc state if data is gone
        if (context.mounted) {
          // Re-check mount status after async gap
          // context.read<ActivityBloc>().add(LoadInitialActivities()); // Example event
        }
      } catch (e) {
        print("Error clearing cache: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Error clearing cache."),
                backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // Helper widget to build consistent ListTiles (same as before)
  Widget _buildSettingsTile({
    /* ... same implementation ... */
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

  // Helper for the divider (same as before)
  Widget _buildDivider() {
    /* ... same implementation ... */
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
