import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';

class DashboardStyles {
  static double cardIconSize = 32.0;
  static double avatarSize = 40.0;

  static BoxDecoration menuCardDecoration = BoxDecoration(
    color: AppStyles.cardColor,
    borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
    boxShadow: AppStyles.shadowSmall,
  );

  static BoxDecoration iconBoxDecoration = BoxDecoration(
    color: AppStyles.cardColor,
    borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
    boxShadow: AppStyles.shadowSmall,
  );

  static BoxDecoration contentDecoration = BoxDecoration(
    color: AppStyles.cardColor,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  );

  static TextStyle getResponsiveMenuTitleStyle(BuildContext context) {
    return AppStyles.body1.copyWith(
      fontSize: AppStyles.getResponsiveFontSize(context, 14),
      fontWeight: FontWeight.w500,
    );
  }

  static double getCardIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= AppStyles.mobileBreakpoint) return 24.0;
    if (width <= AppStyles.tabletBreakpoint) return 28.0;
    return 32.0;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= AppStyles.mobileBreakpoint) return 2;
    if (width <= AppStyles.tabletBreakpoint) return 3;
    if (width <= AppStyles.desktopBreakpoint) return 4;
    return 6;
  }

  static double getGridSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= AppStyles.mobileBreakpoint) return AppStyles.spacing12;
    if (width <= AppStyles.tabletBreakpoint) return AppStyles.spacing16;
    return AppStyles.spacing24;
  }

  static EdgeInsets getContentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= AppStyles.mobileBreakpoint) {
      return const EdgeInsets.all(AppStyles.spacing16);
    }
    if (width <= AppStyles.tabletBreakpoint) {
      return const EdgeInsets.all(AppStyles.spacing24);
    }
    return const EdgeInsets.all(AppStyles.spacing32);
  }
}
