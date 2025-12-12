import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: GotchaApp()));
}

class GotchaApp extends StatelessWidget {
  const GotchaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotcha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryText,
        // We use a dark theme base
        brightness: Brightness.dark,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.abrilFatface(
            color: AppColors.primaryText,
          ),
          bodyMedium: GoogleFonts.anonymousPro(
            color: AppColors.primaryText,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}