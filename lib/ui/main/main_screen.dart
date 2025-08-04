import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
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
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 4;

  /// widget list
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? SafeArea(
              bottom: true,
              child: AnimatedNotchBottomBar(
                /// Provide NotchBottomBarController
                notchBottomBarController: _controller,
                color: Colors.white30,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 5,
                kBottomRadius: 28.0,

                // notchShader: const SweepGradient(
                //   startAngle: 0,
                //   endAngle: pi / 2,
                //   colors: [Colors.red, Colors.green, Colors.orange],
                //   tileMode: TileMode.mirror,
                // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
                notchColor: Colors.white60,

                /// restart app if you change removeMargins
                removeMargins: false,
                bottomBarWidth: 300,
                durationInMilliSeconds: 300,
                elevation: 1,
                showBlurBottomBar: true,
                blurOpacity: 0.4,
                blurFilterX: 5.0,
                blurFilterY: 15.0,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home_filled,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.home_filled,
                      color: AppColors.primary,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.shopping_bag,
                      color: AppColors.primary,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.timelapse_outlined,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.timelapse_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.settings,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24.0,
              ),
            )
          : null,
    );
  }
}
