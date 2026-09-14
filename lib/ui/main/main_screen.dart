import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:manage_salary/ui/home/home_screen.dart';
import 'package:manage_salary/ui/recurring/recurring_management_screen.dart';
import 'package:manage_salary/ui/settings/settings_screen.dart';

import '../../core/constants/colors.dart';
import '../budget/budget_management_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<Widget> bottomBarPages = [
    HomeScreen(),
    BudgetManagementScreen(),
    RecurringManagementScreen(),
    SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.darkSurface.withValues(alpha: 0.8)
                      : AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(32.0),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.home_outlined, Icons.home_filled, AppColors.primary),
                    _buildNavItem(1, Icons.pie_chart_outline, Icons.pie_chart, AppColors.primary),
                    _buildNavItem(2, Icons.repeat_rounded, Icons.repeat_rounded, AppColors.primary),
                    _buildNavItem(3, Icons.settings_outlined, Icons.settings, AppColors.accent),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, Color activeColor) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isSelected ? activeIcon : inactiveIcon,
            key: ValueKey<bool>(isSelected),
            color: isSelected ? activeColor : inactiveColor,
            size: 26,
          ),
        ),
      ),
    );
  }
}

