import 'package:flutter/material.dart';
import 'package:cloudcommerce/styles/app_styles.dart';

class ProductListingStyle {
  InputDecoration get searchInputDecoration => InputDecoration(
        labelText: 'Search Products',
        labelStyle: AppStyles.body2,
        prefixIcon: Icon(Icons.search, color: AppStyles.secondaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
          borderSide: BorderSide(color: AppStyles.secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
          borderSide:
              BorderSide(color: AppStyles.secondaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
          borderSide: BorderSide(color: AppStyles.primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppStyles.spacing12,
          horizontal: AppStyles.spacing16,
        ),
        fillColor: AppStyles.backgroundColor,
        filled: true,
      );

  BoxDecoration get filterOptionDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(
          color: AppStyles.secondaryColor.withOpacity(0.2),
        ),
      );

  BoxDecoration get selectedFilterOptionDecoration => BoxDecoration(
        color: AppStyles.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(
          color: AppStyles.primaryColor,
        ),
      );

  SliverGridDelegateWithFixedCrossAxisCount getGridDelegate(
      BoxConstraints constraints) {
    int crossAxisCount = 2;
    if (constraints.maxWidth > AppStyles.desktopBreakpoint) {
      crossAxisCount = 4;
    } else if (constraints.maxWidth > AppStyles.tabletBreakpoint) {
      crossAxisCount = 3;
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: AppStyles.spacing16,
      mainAxisSpacing: AppStyles.spacing16,
      childAspectRatio: 0.7,
    );
  }

  ButtonStyle get filterDialogButtonStyle => ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
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
