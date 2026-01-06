
import 'package:flutter/material.dart';
import 'package:mini_social/app/theme/app_colors.dart';

class CustomTextStyles { 
  static const TextStyle loginTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: CustomColors.primaryText,
  );
  
  static const TextStyle loginSubtitle = TextStyle(
    fontSize: 16,
    color: CustomColors.secondaryText,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.2,
  );
  
  static const TextStyle loginButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: CustomColors.primaryText,
  );
  
  // Feed Page Styles
  static const TextStyle feedTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: CustomColors.primaryText,
    letterSpacing: 1.2,
  );
  
  static const TextStyle feedSubtitle = TextStyle(
    fontSize: 16,
    color: CustomColors.secondaryText,
    fontWeight: FontWeight.w300,
  );
  
  static TextStyle feedHint = TextStyle(
    fontSize: 14,
    color: CustomColors.secondaryText.withOpacity(0.8),
  );
  
  // Post Card Styles
  static const TextStyle postUsername = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: CustomColors.primaryText,
  );
  
  static TextStyle postTimestamp = TextStyle(
    color: CustomColors.secondaryText,
    fontSize: 12,
  );
  
  static TextStyle postCaption = TextStyle(
    fontSize: 15,
    color: CustomColors.secondaryText,
    height: 1.5,
  );
  
  static TextStyle postStats = TextStyle(
    fontWeight: FontWeight.w600,
    color: CustomColors.secondaryText,
  );
  
  // Create Post Styles
  static const TextStyle createPostTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: CustomColors.primaryText,
    letterSpacing: 1.2,
  );
  
  static const TextStyle createPostLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.secondaryText,
  );
  
  static TextStyle createPostHint = TextStyle(
    fontSize: 15,
    color: CustomColors.hintText,
  );
  
  static const TextStyle createPostButton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.primaryText,
  );
  
  // Button Text Styles
  static const TextStyle buttonPrimary = TextStyle(
    color: CustomColors.primaryText,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle buttonSecondary = TextStyle(
    color: CustomColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  // Dialog Styles
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: CustomColors.primaryText,
  );
  
  static const TextStyle dialogContent = TextStyle(
    fontSize: 16,
    color: CustomColors.secondaryText,
  );
  
  // Comment Styles
  static const TextStyle commentUsername = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: CustomColors.primaryText,
  );
  
  static const TextStyle commentText = TextStyle(
    fontSize: 14,
    color: CustomColors.secondaryText,
  );
  
  static const TextStyle commentTimestamp = TextStyle(
    fontSize: 10,
    color: CustomColors.hintText,
  );
  
  // Error/Success Messages
  static TextStyle errorMessage = TextStyle(
    color: CustomColors.error.withOpacity(0.9),
    fontSize: 14,
  );
  
  static TextStyle successMessage = TextStyle(
    color: CustomColors.success.withOpacity(0.9),
    fontSize: 14,
  );
  
  // Empty State
  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: CustomColors.secondaryText,
  );
  
  static TextStyle emptyStateSubtitle = TextStyle(
    color: CustomColors.hintText,
    fontSize: 16,
  );
  
  // Loading Text
  static TextStyle loadingText = TextStyle(
    color: CustomColors.secondaryText.withOpacity(0.7),
    fontSize: 14,
  );
  
  // Gradient Text Shader
  static Shader get whiteGradientShader => const LinearGradient(
    colors: [
      CustomColors.primaryText,
      Color(0xFFB0B0B0), // Lighter gray
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  
  // App Bar Styles
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: CustomColors.primaryText,
  );
  
  // Section Headers
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: CustomColors.primaryText,
  );
  
  // Input Field Styles
  static TextStyle inputText = TextStyle(
    fontSize: 16,
    color: CustomColors.primaryText,
  );
  
  static TextStyle inputHint = TextStyle(
    color: CustomColors.hintText,
    fontSize: 14,
  );
}