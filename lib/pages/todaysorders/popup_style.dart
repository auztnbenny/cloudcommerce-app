import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class OrderDetailsStyle {
  TextStyle get labelStyle => AppStyles.body2.copyWith(
        fontWeight: FontWeight.w600,
      );

  TextStyle get valueStyle => AppStyles.body1;

  TextStyle get totalLabelStyle => AppStyles.h3.copyWith(
        fontWeight: FontWeight.bold,
      );

  TextStyle get totalValueStyle => AppStyles.h2.copyWith(
        color: AppStyles.primaryColor,
        fontWeight: FontWeight.bold,
      );

  TextStyle get tableHeaderStyle => AppStyles.body2.copyWith(
        fontWeight: FontWeight.bold,
      );

  TextStyle get tableContentStyle => AppStyles.body2;

  RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      );

  BoxDecoration get summaryContainerDecoration => BoxDecoration(
        color: AppStyles.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppStyles.radiusMedium),
          bottomRight: Radius.circular(AppStyles.radiusMedium),
        ),
      );

  ButtonStyle get retryButtonStyle => ElevatedButton.styleFrom(
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
