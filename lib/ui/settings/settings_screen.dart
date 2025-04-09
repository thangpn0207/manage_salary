import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/bloc/theme/cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return DropdownButton<ThemeMode>(
                  value: state,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setTheme(value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Language',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, state) {
                return DropdownButton<Locale>(
                  value: state,
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Spanish'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fr'),
                      child: Text('French'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<LocaleCubit>().setLocale(value);
                    }
                  },
                );
              },
            ),
          ],
        ),
      )
     ;
  }
}