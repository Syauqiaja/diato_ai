import 'package:flutter/material.dart';

class AppTheme {
  // Color definitions
  static const Color primaryColor = Color(0xFF3F4EB8);
  static const Color secondaryColor = Color(0xFF81E4EA);
  static const Color tertiaryColor = Color(0xFFFBCF98);
  static const Color canvasColor = Colors.white;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        primaryContainer: primaryColor.withValues(alpha: 0.1),
        onPrimaryContainer: primaryColor,
        
        secondary: secondaryColor,
        onSecondary: Colors.black,
        secondaryContainer: secondaryColor.withValues(alpha: 0.1),
        onSecondaryContainer: secondaryColor,
        
        tertiary: tertiaryColor,
        onTertiary: Colors.black,
        tertiaryContainer: tertiaryColor.withValues(alpha: 0.1),
        onTertiaryContainer: tertiaryColor,
        
        surface: canvasColor,
        onSurface: Colors.black87,
        
        error: const Color(0xFFB00020),
        onError: Colors.white,
      ),
      
      // Canvas Color
      canvasColor: canvasColor,
      scaffoldBackgroundColor: canvasColor,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: canvasColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB00020)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      
      // Icon Theme
      iconTheme: IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: canvasColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: tertiaryColor.withValues(alpha: 0.2),
        selectedColor: tertiaryColor,
        labelStyle: const TextStyle(color: Colors.black87),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: canvasColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}
