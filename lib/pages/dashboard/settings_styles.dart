import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';

class SettingsStyles {
  // Text Styles
  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppStyles.secondaryColor,
  );

  static TextStyle menuItemStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppStyles.textPrimaryColor,
    fontFamily: AppStyles.fontFamily,
  );

  // Layout
  static EdgeInsets screenPadding = const EdgeInsets.symmetric(
    horizontal: AppStyles.spacing16,
    vertical: AppStyles.spacing8,
  );

  static EdgeInsets itemPadding = const EdgeInsets.symmetric(
    vertical: AppStyles.spacing12,
    horizontal: AppStyles.spacing8,
  );

  // Item Decoration
  static BoxDecoration itemDecoration = const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xFFEEEEEE),
        width: 0.5,
      ),
    ),
  );

  // Colors for specific items
  static const Color deleteColor = Color(0xFFDC3545);
}
