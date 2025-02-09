import 'package:flutter/material.dart';

class ColorPalette {
  // Primary colors
  static const Color primaryColor = Color(0xFFFFFFFF);  // Kept white
  static const Color secondaryColor = Color(0xFF4CAF50);  // Kept original green
  static const Color accentColor = Color(0xFF2C5A40);    // Kept original accent
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF8FAF9); // Light with slight green tint
  static const Color surfaceColor = Color(0xFFFFFFFF);   // Pure white
  static const Color cardColor = Color(0xFFF5F8F6);      // Very light green tint
  
  // Text colors
  static  Color primaryText =  const Color.fromARGB(255, 44, 90, 64).withGreen(105);    // Dark green-gray
  static const Color secondaryText = Color(0xFF5C6964);  // Medium green-gray
  static const Color disabledText = Color(0xFFADB5B2);   // Light green-gray
  
  // Form colors
  static const Color textFieldBackground = Color(0xFFF5F8F6);  // Very light green tint
  static const Color textFieldBorder = Color(0xFFE0E5E3);      // Light gray with green tint
  static const Color textFieldFocusedBorder = Color(0xFF4CAF50); // Kept original green
  static const Color textFieldErrorBorder = Color(0xFFE57373);   // Kept original error
  
  // Selection colors
  static const Color selectionColor = Color(0xFF4CAF50);      // Kept original green
  static const Color selectionHandleColor = Color(0xFF81C784); // Kept original
  
  // Button colors
  static const Color primaryButton = Color(0xFF2C5A40);       // Kept original
  static const Color primaryButtonHover = Color(0xFF376E4D);  // Kept original
  static const Color primaryButtonSplash = Color(0xFF4CAF50); // Kept original
  static const Color secondaryButton = Color(0xFFE8F0EC);     // Very light green tint
  static const Color disabledButton = Color(0xFFEEF1EF);      // Light gray with slight green
  
  // Accent colors
  static const Color success = Color(0xFF81C784);  // Kept original
  static const Color error = Color(0xFFE57373);    // Kept original
  static const Color warning = Color(0xFFFFB74D);  // Kept original
  static const Color info = Color(0xFF64B5F6);     // Kept original
}