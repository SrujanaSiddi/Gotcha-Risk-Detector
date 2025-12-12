import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background colour: #2e0d14
  static const Color background = Color(0xFF2e0d14);
  
  // Text Colour: #efe1d6
  static const Color primaryText = Color(0xFFefe1d6);
  
  // Container Color (Beige/Off-white used in UI)
  static const Color containerBg = Color(0xFFefe1d6);
  
  // Risk Colors
  static const Color riskHigh = Color(0xFFff3131); // Red
  static const Color riskModerate = Color(0xFFffeb00); // Yellow
  static const Color riskSelected = Color(0xFF5e17eb); // Purple
}

class AppTextStyles {
  // “GOTCHA” (Result Screen)
  static TextStyle get titleLarge => GoogleFonts.abrilFatface(
    fontSize: 50, // Safe size for results
    color: AppColors.primaryText,
    shadows: [
      Shadow(
        offset: const Offset(4, 4),
        blurRadius: 6,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  );

  // “GOTCHA” (Home Screen) - REDUCED SIZE
  static TextStyle get homeTitle => GoogleFonts.abrilFatface(
    fontSize: 72, // Reduced from 96 to prevent overflow
    color: AppColors.primaryText,
    shadows: [
      Shadow(
        offset: const Offset(4, 4),
        blurRadius: 6,
        color: Colors.black.withOpacity(0.5),
      ),
    ],
  );

  // “Too Long, Didn’t Read”
  static TextStyle get cursiveSubtitle => GoogleFonts.satisfy(
    fontSize: 28, // Slightly smaller
    color: AppColors.primaryText,
  );

  // “Paste Terms...”
  static TextStyle get placeholder => GoogleFonts.anonymousPro(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: AppColors.background.withOpacity(0.4), 
  );
  
  static TextStyle get safetyScore => GoogleFonts.anonymousPro(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );
  
  static TextStyle get analysisBody => GoogleFonts.arimo(
    fontSize: 16,
    color: const Color(0xFF2e0d14),
  );
  
  static TextStyle get riskTitle => GoogleFonts.anonymousPro(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  );
}