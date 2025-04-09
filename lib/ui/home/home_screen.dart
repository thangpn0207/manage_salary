import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:manage_salary/ui/components/base_button.dart';

import '../../core/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tilt(
          borderRadius: BorderRadius.circular(30),
          tiltConfig: const TiltConfig(
            angle: 30,
            leaveDuration: Duration(seconds: 1),
            leaveCurve: Curves.bounceOut,
          ),
          childLayout: ChildLayout(
            outer: [
              Positioned(
                child: TiltParallax(
                  size: Offset(40, 40),
                  child: Text(
                    '\$2000',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            width: 350,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.primary, AppColors.onSurface],
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child:
                BaseButton(width: 350, text: "Add Expense", onPressed: () {}, icon: const Icon(Icons.add)),)
      ],
    );
  }
}
