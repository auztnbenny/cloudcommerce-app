import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';

class OrderStyles {
  // Colors - Using AppStyles colors
  static const Color labelColor = AppStyles.secondaryColor;

  // Text Styles
  static TextStyle headerTitleStyle = AppStyles.h1.copyWith(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle orderNumberStyle = AppStyles.h2.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle labelStyle = AppStyles.body2.copyWith(
    color: labelColor,
    fontSize: 13,
  );

  static TextStyle valueStyle = AppStyles.body1.copyWith(
    color: AppStyles.textPrimaryColor,
    fontSize: 15,
  );

  static TextStyle amountStyle = AppStyles.body1.copyWith(
    color: Colors.green,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  // Decorations
  static BoxDecoration appBarDecoration = BoxDecoration(
    color: Colors.black,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration orderCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Dimensions
  static const double appBarHeight = 65.0;
  static const double searchBarHeight = 50.0;

  // Spacing
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets listPadding = EdgeInsets.all(16.0);
  static const double cardSpacing = 12.0;
  static const double infoSpacing = 8.0;
  static const double sectionSpacing = 16.0;
}
