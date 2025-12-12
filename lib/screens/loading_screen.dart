import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';
import '../logic/guardian_core.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String textToAnalyze;
  const LoadingScreen({super.key, required this.textToAnalyze});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    // Artificial delay to let animation play (User perception)
    final minWait = Future.delayed(const Duration(seconds: 4));
    
    // Actual Analysis
    final analysisFuture = GuardianCore.analyze(widget.textToAnalyze);
    
    // Wait for both
    final results = await Future.wait([minWait, analysisFuture]);
    final report = results[1] as AnalysisReport;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(report: report),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Stack(
            children: [
              // Aligned to Top Left as per prompt
              Positioned(
                top: 0,
                left: 0,
                child: Text("GOTCHA", style: AppTextStyles.titleLarge),
              ),
              
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // loadingAnimation
                    const SeesawLoader(),
                    
                    const SizedBox(height: 50),
                    Text(
                      "Looking for trouble...\nliterally",
                      style: GoogleFonts.anonymousPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}