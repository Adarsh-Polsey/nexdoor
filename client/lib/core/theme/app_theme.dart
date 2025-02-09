import 'package:flutter/material.dart';
import 'package:nexdoor/core/theme/color_pallete.dart';

class AppTheme {
  static ThemeData lightColorTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ColorPalette.secondaryColor,
      secondary: ColorPalette.accentColor,
      surface: ColorPalette.surfaceColor,
      error: ColorPalette.error,
      onPrimary: ColorPalette.surfaceColor,
      onSecondary: ColorPalette.surfaceColor,
      onSurface: ColorPalette.primaryText,
      onError: ColorPalette.surfaceColor,
    ),
    
    // Selection Theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalette.selectionColor,
      selectionColor: ColorPalette.selectionColor.withValues(alpha:0.3),
      selectionHandleColor: ColorPalette.selectionHandleColor,
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorPalette.textFieldBackground,
      focusColor: ColorPalette.textFieldFocusedBorder,
      hoverColor: ColorPalette.textFieldBackground.withValues(alpha:0.8),
      
      // Border styling
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.textFieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.textFieldFocusedBorder, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.textFieldBorder),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.textFieldErrorBorder),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: ColorPalette.textFieldErrorBorder, width: 2),
      ),
      
      // Text styling
      labelStyle: TextStyle(color: ColorPalette.secondaryText),
      hintStyle: TextStyle(color: ColorPalette.disabledText),
      errorStyle: TextStyle(color: ColorPalette.error),
      
      // Padding and constraints
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      isDense: true,
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) return ColorPalette.disabledButton;
          if (states.contains(WidgetState.pressed)) return ColorPalette.primaryButtonSplash;
          if (states.contains(WidgetState.hovered)) return ColorPalette.primaryButtonHover;
          return ColorPalette.primaryButton;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) return ColorPalette.disabledText;
          return ColorPalette.surfaceColor;
        }),
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          if (states.contains(WidgetState.pressed)) return 0;
          if (states.contains(WidgetState.hovered)) return 4;
          return 2;
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) return ColorPalette.disabledText;
          return ColorPalette.accentColor;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: ColorPalette.disabledText);
          }
          return BorderSide(color: ColorPalette.accentColor);
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) return ColorPalette.disabledText;
          if (states.contains(WidgetState.pressed)) return ColorPalette.primaryButtonSplash;
          if (states.contains(WidgetState.hovered)) return ColorPalette.primaryButtonHover;
          return ColorPalette.accentColor;
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: ColorPalette.surfaceColor,
      foregroundColor: ColorPalette.primaryText,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorPalette.primaryText),
      actionsIconTheme: IconThemeData(color: ColorPalette.accentColor),
      centerTitle: true,
    ),
    
    // Drawer Theme
    drawerTheme: DrawerThemeData(
      backgroundColor: ColorPalette.surfaceColor,
      scrimColor: ColorPalette.primaryText.withValues(alpha:0.2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),
    
    // Navigation Rail Theme
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: ColorPalette.surfaceColor,
      selectedIconTheme: IconThemeData(color: ColorPalette.secondaryColor),
      unselectedIconTheme: IconThemeData(color: ColorPalette.secondaryText),
      selectedLabelTextStyle: TextStyle(
        color: ColorPalette.secondaryColor,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: ColorPalette.secondaryText,
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorPalette.surfaceColor,
      selectedItemColor: ColorPalette.secondaryColor,
      unselectedItemColor: ColorPalette.secondaryText,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
      elevation: 8,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: ColorPalette.surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
    
    // List Tile Theme
    listTileTheme: ListTileThemeData(
      tileColor: ColorPalette.surfaceColor,
      selectedTileColor: ColorPalette.secondaryColor.withValues(alpha:0.1),
      iconColor: ColorPalette.secondaryText,
      selectedColor: ColorPalette.secondaryColor,
      textColor: ColorPalette.primaryText,
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.secondaryColor,
      foregroundColor: ColorPalette.surfaceColor,
      elevation: 4,
      highlightElevation: 8,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(color: ColorPalette.primaryText),
      displayMedium: TextStyle(color: ColorPalette.primaryText),
      displaySmall: TextStyle(color: ColorPalette.primaryText),
      headlineMedium: TextStyle(color: ColorPalette.primaryText),
      headlineSmall: TextStyle(color: ColorPalette.primaryText),
      titleLarge: TextStyle(color: ColorPalette.primaryText, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: ColorPalette.secondaryText),
      titleSmall: TextStyle(color: ColorPalette.secondaryText),
      bodyLarge: TextStyle(color: ColorPalette.primaryText),
      bodyMedium: TextStyle(color: ColorPalette.secondaryText),
      bodySmall: TextStyle(color: ColorPalette.disabledText),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: ColorPalette.primaryText,
      size: 24,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: ColorPalette.textFieldBorder,
      thickness: 1,
      space: 1,
    ),
    
    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: ColorPalette.cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: TextStyle(color: ColorPalette.primaryText),
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorPalette.cardColor,
      contentTextStyle: TextStyle(color: ColorPalette.primaryText),
      actionTextColor: ColorPalette.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: ColorPalette.cardColor,
      selectedColor: ColorPalette.secondaryColor,
      disabledColor: ColorPalette.disabledButton,
      labelStyle: TextStyle(color: ColorPalette.primaryText),
      secondaryLabelStyle: TextStyle(color: ColorPalette.surfaceColor),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}