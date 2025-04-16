import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double x;
  final double y;

  const CustomFloatingActionButtonLocation({
    required this.x,
    required this.y,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Calculate the available space
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double contentRight = scaffoldGeometry.scaffoldSize.width;
    
    // Get FAB size
    final double fabWidth = scaffoldGeometry.floatingActionButtonSize.width;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;

    // Calculate position ensuring FAB stays within bounds
    final double xPosition = x.clamp(0, contentRight - fabWidth);
    final double yPosition = y.clamp(0, contentBottom - fabHeight);

    return Offset(xPosition, yPosition);
  }
}