import 'package:flutter/material.dart';

class BottomNavStyles {
  static const Color activeColor = Colors.black;
  static const Color inactiveColor = Colors.grey;

  // FAB Theme
  static final FloatingActionButtonThemeData fabTheme =
      FloatingActionButtonThemeData(
    backgroundColor: Colors.pink[300],
    elevation: 4,
    shape: const CircleBorder(),
  );

  // Responsive FAB sizes
  static double getFabSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 48.0;
    if (screenWidth < 400) return 52.0;
    return 56.0;
  }

  static double getFabIconSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) return 24.0;
    if (screenWidth < 400) return 28.0;
    return 32.0;
  }

  // Colors and styles for the navigation bar itself
  static final BoxDecoration navDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, -2),
        blurRadius: 8,
      ),
    ],
  );

  static TextStyle getTextStyle(bool isActive) {
    return TextStyle(
      color: isActive ? activeColor : inactiveColor,
      fontSize: 12,
      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
    );
  }

  static Color getIconColor(bool isActive) {
    return isActive ? activeColor : inactiveColor;
  }
}
