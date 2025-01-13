import 'package:cloudcommerce/styles/app_styles.dart';
import 'package:flutter/material.dart';

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
      childAspectRatio: 0.7, // Changed from 0.75 to 0.7 to provide more height
    );
  }
}
