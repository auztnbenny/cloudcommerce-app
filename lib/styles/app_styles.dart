import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF666666);
  static const Color backgroundColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color errorColor = Color(0xFFDC3545);

  // Typography
  static TextStyle get displayLarge => GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get h1 => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      );

  static TextStyle get h2 => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );
  static TextStyle get h3 => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
      );

  static TextStyle get body1 => GoogleFonts.montserrat(
        fontSize: 16,
        color: textPrimaryColor,
      );

  static TextStyle get body2 => GoogleFonts.montserrat(
        fontSize: 14,
        color: textSecondaryColor,
      );

  static TextStyle get button => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: 12,
        color: textSecondaryColor,
      );

  // Responsive Breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1200;

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Shadows
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static var fontFamily;

  // Responsive Helpers
  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= mobileBreakpoint) return spacing16;
    if (width <= tabletBreakpoint) return spacing24;
    return spacing32;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width <= mobileBreakpoint) return baseSize * 0.9;
    if (width <= tabletBreakpoint) return baseSize;
    return baseSize * 1.1;
  }

  static double getResponsiveSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= mobileBreakpoint) return spacing12;
    if (width <= tabletBreakpoint) return spacing16;
    return spacing24;
  }

  // AppBar Styles
  static const double appBarHeight = 60.0;

  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final BoxDecoration appBarDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(1),
      bottomRight: Radius.circular(1),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static const TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double horizontal = spacing16;

    if (width > mobileBreakpoint) horizontal = width * 0.1;
    if (width > tabletBreakpoint) horizontal = width * 0.15;
    if (width > desktopBreakpoint) horizontal = width * 0.2;

    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: spacing16,
    );
  }
}
