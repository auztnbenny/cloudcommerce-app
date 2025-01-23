import 'package:flutter/material.dart';

class PaymentDetailsStyles {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color backgroundColor = Colors.white;

  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle tableHeaderStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle tableCellStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );

  // Table Decoration
  static const EdgeInsets tablePadding = EdgeInsets.all(8.0);
  static const EdgeInsets tableMargin = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );

  // Loading and Error Styles
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );
}
