import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class OrderDetailsStyle {
  TextStyle get labelStyle => AppStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
        color: AppStyles.textSecondaryColor,
      );

  TextStyle get valueStyle => AppStyles.body1;

  TextStyle get stockAvailableStyle => AppStyles.body2.copyWith(
        color: Colors.green,
        fontWeight: FontWeight.w500,
      );

  TextStyle get stockUnavailableStyle => AppStyles.body2.copyWith(
        color: Colors.red,
        fontWeight: FontWeight.w500,
      );

  TextStyle get inputLabelStyle => AppStyles.body1.copyWith(
        fontWeight: FontWeight.w600,
        color: AppStyles.textPrimaryColor,
      );

  InputDecoration getInputDecoration({String? label, String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          borderSide: BorderSide(color: AppStyles.secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
          borderSide:
              BorderSide(color: AppStyles.secondaryColor.withOpacity(0.5)),
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

  ButtonStyle get expandMoreButtonStyle => ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(Size(0, 0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
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
