import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CartStyles {
  // Item card styling
  static BoxDecoration get itemDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );

  // Quantity control button styling
  static BoxDecoration get quantityButtonDecoration => BoxDecoration(
        border: Border.all(
          color: AppStyles.secondaryColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
      );

  // Summary container styling
  static BoxDecoration get summaryDecoration => BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppStyles.radiusLarge),
          topRight: Radius.circular(AppStyles.radiusLarge),
        ),
      );

  // Typography styles
  static TextStyle get itemNameStyle => AppStyles.body1.copyWith(
        fontWeight: FontWeight.w500,
      );

  static TextStyle get priceStyle => AppStyles.body1.copyWith(
        fontWeight: FontWeight.w600,
        color: AppStyles.primaryColor,
      );

  static TextStyle get totalPriceStyle => AppStyles.h2.copyWith(
        fontWeight: FontWeight.w600,
        color: AppStyles.primaryColor,
      );

  // Button styles
  static ButtonStyle get checkoutButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: AppStyles.spacing16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        ),
        elevation: 0,
      );
}
