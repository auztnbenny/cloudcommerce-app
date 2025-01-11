import 'package:flutter/material.dart';

class OrderStyles {
  // Colors
  static const Color primaryTextColor = Colors.black;
  static const Color secondaryTextColor = Colors.grey;
  static const Color statusColor = Colors.green;
  static const Color ratingColor = Colors.amber;
  static const Color fabColor = Colors.deepPurple;
  static const Color backgroundColor = Colors.white;

  // Dimensions
  static const double imageSize = 50.0;
  static const double spacing = 16.0;
  static const double smallSpacing = 8.0;
  static const double starSize = 16.0;
  static const double borderRadius = 8.0;
  static const double dividerHeight = 32.0;

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static const TextStyle orderIdStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
  );

  static const TextStyle dateTimeStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );

  static const TextStyle statusStyle = TextStyle(
    fontSize: 14,
    color: statusColor,
  );

  static const TextStyle ratingLabelStyle = TextStyle(
    fontSize: 14,
    color: secondaryTextColor,
  );

  // Decorations
  static BoxDecoration imageDecoration(String imagePath) => BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      );

  static const EdgeInsets listPadding = EdgeInsets.all(spacing);
}
