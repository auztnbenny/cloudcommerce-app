import 'package:flutter/material.dart';
import 'app_styles.dart';

class BottomNavStyles {
  static const double navHeight = 65.0;
  static const double fabSize = 56.0;
  static const double iconSize = 28.0;

  static BoxDecoration navDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, -5),
      ),
    ],
  );

  static FloatingActionButtonThemeData fabTheme = FloatingActionButtonThemeData(
    backgroundColor: Colors.pink[300],
    shape: const CircleBorder(),
    elevation: 4,
  );

  static const IconThemeData activeIconTheme = IconThemeData(
    color: Colors.black,
    size: iconSize,
  );

  static const IconThemeData inactiveIconTheme = IconThemeData(
    color: Colors.grey,
    size: iconSize,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}
