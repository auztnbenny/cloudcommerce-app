import 'package:flutter/material.dart';

class OrderStyles {
  // Colors
  static const Color primaryColor = Color(0xFF000000);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF2D3142);
  static const Color textSecondaryColor = Color(0xFF666666);
  static const Color amountColor = Colors.green;
  static const Color labelColor = textSecondaryColor;
  static const Color statusBackground = Colors.black12;

  // Text Styles
  static const TextStyle headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle orderNumberStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle amountStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle partyNameStyle = TextStyle(
    fontSize: 15,
    color: textPrimaryColor,
  );

  static const TextStyle dateStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  static const TextStyle itemCountStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle valueStyle = TextStyle(
    fontSize: 14,
    color: textPrimaryColor,
  );

  static const TextStyle dialogTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle chipStyle = TextStyle(
    fontSize: 12,
    color: textPrimaryColor,
  );

  static const TextStyle statusStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  // Decorations
  static final BoxDecoration appBarDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final BoxDecoration orderCardDecoration = BoxDecoration(
    // Renamed from cardDecoration
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static final BoxDecoration searchBarDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: textSecondaryColor.withOpacity(0.2)),
  );

  static final BoxDecoration dialogDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  );

  static final BoxDecoration statusChipDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: BorderRadius.circular(12),
  );

  // Input Decorations
  static final InputDecoration searchInputDecoration = InputDecoration(
    hintText: 'Search orders...',
    hintStyle: const TextStyle(color: textSecondaryColor),
    prefixIcon: const Icon(Icons.search, color: textSecondaryColor),
    filled: true,
    fillColor: cardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: textSecondaryColor.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor),
    ),
  );

  static final InputDecoration filterInputDecoration = InputDecoration(
    labelStyle: const TextStyle(color: textSecondaryColor),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: textSecondaryColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  );

  static final ButtonStyle secondaryButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.grey[700],
  );

  // Dimensions & Spacing
  static const double appBarHeight = 60.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double infoSpacing = 8.0;
  static const double sectionSpacing = 12.0;
  static const double cardSpacing = 12.0; // Added missing cardSpacing

  // Padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets listPadding = EdgeInsets.all(spacing);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
}
