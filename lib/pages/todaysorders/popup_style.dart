import 'package:cloudcommerce/pages/todaysorders/popup.dart';
import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class ProductDialogStyle {
  TextStyle get labelStyle => AppStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
      );

  InputDecoration get inputDecoration => InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          borderSide: BorderSide(color: AppStyles.secondaryColor),
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
        fillColor: AppStyles.backgroundColor,
      );

  BoxDecoration get headerDecoration => BoxDecoration(
        color: AppStyles.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusMedium),
          topRight: Radius.circular(AppStyles.radiusMedium),
        ),
      );

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
}
