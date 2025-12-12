import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../logic/guardian_core.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisReport report;
  const ResultScreen({super.key, required this.report});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  RiskPattern? _selectedPattern;

  void _handleHighlightTap(RiskPattern pattern) {
    setState(() {
      _selectedPattern = pattern;
    });
  }

  void _refresh() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start (left)
            children: [
               Text("GOTCHA", style: AppTextStyles.titleLarge.copyWith(fontSize: 40)),
               const SizedBox(height: 10),
               
               // Score Display
               Center(
                 child: Text(
                   "Safety Score: ${widget.report.score}%", 
                   style: AppTextStyles.safetyScore.copyWith(fontSize: 28),
                 ),
               ),
               const SizedBox(height: 20),
               
               // analysisText Area
               Expanded(
                 child: Container(
                   width: double.infinity,
                   decoration: BoxDecoration(
                     color: AppColors.containerBg,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   padding: const EdgeInsets.all(20),
                   child: SingleChildScrollView(
                     child: RichText(
                       text: TextSpan(
                         children: _buildTextSpans(),
                         style: AppTextStyles.analysisBody,
                       ),
                     ),
                   ),
                 ),
               ),
               
               const SizedBox(height: 15),
               
               // Conditional Spawning Container (Risk Detail)
               if (_selectedPattern != null)
                 Container(
                   margin: const EdgeInsets.only(bottom: 15),
                   padding: const EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     color: AppColors.containerBg,
                     borderRadius: BorderRadius.circular(15),
                     border: Border.all(color: Colors.transparent),
                   ),
                   child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Color Indicator
                       Container(
                         width: 20, height: 20,
                         decoration: BoxDecoration(
                           color: _selectedPattern!.isHighRisk ? AppColors.riskHigh : AppColors.riskModerate,
                           shape: BoxShape.circle,
                           border: Border.all(color: Colors.black, width: 1),
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               _selectedPattern!.category,
                               style: AppTextStyles.riskTitle,
                             ),
                             const SizedBox(height: 5),
                             Text(
                               _selectedPattern!.description,
                               style: AppTextStyles.analysisBody.copyWith(fontSize: 14),
                             ),
                           ],
                         ),
                       )
                     ],
                   ),
                 ),

               // refreshIcon
               Center(
                 child: GestureDetector(
                   onTap: _refresh,
                   child: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.containerBg,
                      child: Icon(Icons.refresh, color: AppColors.background, size: 35),
                   ),
                 ),
               ),
               const SizedBox(height: 15),
               
               // Legend (Wrapped in Container as per Requirement 4)
               Container(
                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                 decoration: BoxDecoration(
                   color: AppColors.containerBg,
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                          _buildLegendItem(AppColors.riskHigh, "High Risk"),
                          if (_selectedPattern != null)
                             _buildLegendItem(AppColors.riskSelected, "Current risk"),
                       ],
                     ),
                     const SizedBox(height: 8),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(AppColors.riskModerate, "Moderate Risk"),
                        ]
                     )
                   ],
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15, height: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label, 
          style: GoogleFonts.anonymousPro(
            fontWeight: FontWeight.bold, 
            color: const Color(0xFF2e0d14), // Dark Text for inside the beige container
            fontSize: 16
          )
        ),
      ],
    );
  }

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    String text = widget.report.originalText;
    int currentIndex = 0;

    for (var finding in widget.report.findings) {
      // Add non-highlighted text before the match
      if (finding.index > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, finding.index)));
      }

      // Logic for selecting active color
      bool isSelected = _selectedPattern == finding.pattern;
      
      // Default High/Moderate color
      Color highlightColor = finding.pattern.isHighRisk ? AppColors.riskHigh : AppColors.riskModerate;
      
      // Transparency 40% normally, but if selected, it becomes Purple (also 40% transparency in prompt description?)
      if (isSelected) {
        highlightColor = AppColors.riskSelected.withOpacity(0.4);
      } else {
        highlightColor = highlightColor.withOpacity(0.4);
      }

      spans.add(TextSpan(
        text: text.substring(finding.index, finding.index + finding.length),
        style: TextStyle(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()..onTap = () {
          _handleHighlightTap(finding.pattern);
        },
      ));

      currentIndex = finding.index + finding.length;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}