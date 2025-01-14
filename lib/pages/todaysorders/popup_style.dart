// order_details_style.dart
import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class OrderDetailsStyle {
  // Text Styles
  TextStyle get labelStyle => AppStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
        color: AppStyles.textSecondaryColor,
      );

  TextStyle get valueStyle => AppStyles.body1.copyWith(
        color: AppStyles.textPrimaryColor,
      );

  TextStyle get stockStyle => AppStyles.body1.copyWith(
        fontWeight: FontWeight.w500,
      );

  TextStyle get amountStyle => AppStyles.body1.copyWith(
        color: AppStyles.primaryColor,
        fontWeight: FontWeight.w600,
      );

  // Stock Color Styles
  Color getStockColor(String stockColor) {
    switch (stockColor.toUpperCase()) {
      case 'GREEN':
        return Colors.green;
      case 'RED':
        return Colors.red;
      case 'YELLOW':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Input Decoration
  InputDecoration getInputDecoration({
    String? label,
    String? hint,
    Widget? prefix,
    Widget? suffix,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          borderSide: BorderSide(
            color: AppStyles.secondaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          borderSide: BorderSide(color: AppStyles.primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppStyles.spacing12,
          vertical: AppStyles.spacing8,
        ),
        filled: true,
        fillColor: Colors.white,
      );

  // Stock Info Container
  BoxDecoration stockInfoDecoration(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
      );

  // Expansion Panel
  BoxDecoration expansionPanelDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
    border: Border.all(
      color: AppStyles.secondaryColor.withOpacity(0.2),
    ),
  );

  // Buttons
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: AppStyles.primaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: AppStyles.spacing24,
          vertical: AppStyles.spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        ),
      );

  ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: AppStyles.textPrimaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: AppStyles.spacing24,
          vertical: AppStyles.spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        ),
      );
}
