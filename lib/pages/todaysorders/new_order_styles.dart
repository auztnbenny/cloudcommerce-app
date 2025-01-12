import 'package:cloudcommerce/pages/todaysorders/orders_styles.dart';
import 'package:flutter/material.dart';

class NewOrderStyles {
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    color: OrderStyles.textSecondaryColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle inputStyle = TextStyle(
    fontSize: 16,
    color: OrderStyles.textPrimaryColor,
  );

  // Input Decorations
  static InputDecoration getInputDecoration({
    required String label,
    Widget? suffixIcon,
    bool readOnly = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: OrderStyles.textSecondaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: OrderStyles.textSecondaryColor.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: OrderStyles.primaryColor, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Dialog Styles
  static BoxDecoration dialogDecoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static const TextStyle dialogTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: OrderStyles.textPrimaryColor,
  );

  // List Tile Styles
  static const TextStyle listTileTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: OrderStyles.textPrimaryColor,
  );

  static const TextStyle listTileSubtitleStyle = TextStyle(
    fontSize: 14,
    color: OrderStyles.textSecondaryColor,
  );

  // Button Styles
  static final ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: OrderStyles.primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  );

  // Spacing
  static const double verticalSpacing = 16.0;
  static const double horizontalSpacing = 16.0;
  static const double dialogMaxHeight = 400.0;

  // Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets dialogPadding = EdgeInsets.all(20.0);
}
