// lib/app/theme/custom_colors.dart
import 'package:flutter/material.dart';

class CustomColors {
  // Background Colors
  static const Color primaryBackground = Color(0xFF000000); // Black background
  static const Color secondaryBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  
  // Gradient Colors
  static const List<Color> loginGradient = [
    Color.fromARGB(255, 11, 25, 58), // Dark blue
    Color.fromARGB(255, 25, 19, 34), // Dark purple
    Color.fromARGB(255, 19, 7, 20), // Dark pink
  ];
  
  static const List<Color> feedGradient = [
    Color.fromARGB(255, 0, 0, 0), // Dark blue
    Color.fromARGB(255, 15, 15, 15), // Dark purple
  ];
  
  static const List<Color> glassGradient = [
    Color.fromRGBO(255, 255, 255, 0.15),
    Color.fromRGBO(255, 255, 255, 0.05),
  ];
  
  static const List<Color> whiteGradient = [
    Color.fromRGBO(255, 255, 255, 0.25),
    Color.fromRGBO(255, 255, 255, 0.1),
  ];
  
  // Accent Colors
  static const Color primaryAccent = Color.fromARGB(255, 22, 22, 22); // Muted blue
  static const Color secondaryAccent = Color.fromARGB(255, 0, 0, 0); // Purple accent
  static const Color accentPink = Color(0xFFE91E63); // Pink accent
  static const Color accentCyan = Color(0xFF00BCD4); // Cyan accent
  
  // Text Colors
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFB0B0B0);
  static const Color hintText = Color(0xFF666666);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // UI Element Colors
  static const Color divider = Color(0xFF333333);
  static const Color border = Color(0xFF444444);
  static const Color shadow = Color.fromRGBO(0, 0, 0, 0.5);
  
  // Social Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color facebookBlue = Color(0xFF1877F2);
  
  // Button Colors
  static const Color primaryButton = Color(0xFF4A6FA5);
  static const Color secondaryButton = Color(0xFF2D2D2D);
  
  // Icon Colors
  static const Color iconPrimary = Colors.white;
  static const Color iconSecondary = Color(0xFF999999);
  
  // Overlay Colors
  static const Color overlayDark = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color overlayLight = Color.fromRGBO(255, 255, 255, 0.1);
  
  // Glassmorphism Colors
  static List<Color> glassWhite(double opacity) => [
    Colors.white.withOpacity(opacity * 0.25),
    Colors.white.withOpacity(opacity * 0.15),
  ];
  
  static List<Color> glassBlack(double opacity) => [
    Colors.black.withOpacity(opacity * 0.3),
    Colors.black.withOpacity(opacity * 0.1),
  ];
}