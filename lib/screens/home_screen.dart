import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _termsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _clearText() {
    _termsController.clear();
  }

  void _processText() {
    if (_termsController.text.isEmpty) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(textToAnalyze: _termsController.text),
      ),
    );
  }

  void _copyEmail() {
    Clipboard.setData(const ClipboardData(text: "brucewayne19188@gmail.com"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('E-mail Copied!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // Reduced from 0.5 (50%) to 0.4 (40%) to save space
    final double maxInputHeight = size.height * 0.4;

    return Scaffold(
      // Changed to TRUE so keyboard pushes content up (scrolling enabled)
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          // Background Waves
          Positioned.fill(
            child: CustomPaint(painter: WavesPainter(isTopRight: true)),
          ),
          Positioned.fill(
            child: CustomPaint(painter: WavesPainter(isTopRight: false)),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    // Ensure minimum height matches screen so spacers work
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute vertical space
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top Spacing (Reduced)
                              SizedBox(height: size.height * 0.10), 
                              
                              Text(
                                "Too Long, Didn't Read?",
                                style: AppTextStyles.cursiveSubtitle,
                                textAlign: TextAlign.center,
                              ),
                              
                              FittedBox(
                                fit: BoxFit.scaleDown, // Ensures text scales if screen is too narrow
                                child: Text(
                                  "GOTCHA",
                                  style: AppTextStyles.homeTitle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              
                              const SizedBox(height: 20),

                              // Input Container
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 150, // Minimum clickable size
                                  maxHeight: maxInputHeight,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.containerBg,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    thumbVisibility: true,
                                    child: TextField(
                                      controller: _termsController,
                                      scrollController: _scrollController,
                                      maxLines: null,
                                      minLines: 5,
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 50000,
                                      style: AppTextStyles.analysisBody,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Paste Terms & Conditions here to detect traps...",
                                        hintStyle: AppTextStyles.placeholder,
                                        counterText: "",
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true, 
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 15),

                              // Action Icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end, 
                                children: [
                                  GestureDetector(
                                    onTap: _clearText,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: AppColors.containerBg,
                                      child: Icon(Icons.delete_outline, color: AppColors.background, size: 30),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  GestureDetector(
                                    onTap: _processText,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: AppColors.containerBg,
                                      child: Icon(Icons.search, color: AppColors.background, size: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Footer
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: GestureDetector(
                              onTap: _copyEmail,
                              child: Text(
                                "Contact us: brucewayne19188@gmail.com",
                                style: GoogleFonts.anonymousPro(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                  color: AppColors.primaryText.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}