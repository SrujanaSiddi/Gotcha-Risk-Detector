import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

// --- WAVES PAINTER ---
// Updated to support Top-Right and Bottom-Left configurations
class WavesPainter extends CustomPainter {
  final bool isTopRight;

  WavesPainter({this.isTopRight = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white.withOpacity(0.4) // Visibility matching the design
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5; // Thinner lines for elegance

    var path = Path();

    if (isTopRight) {
      // Draw waves coming from Top-Right Corner
      for (int i = 0; i < 3; i++) {
        double offset = i * 20.0;
        // Start from top edge, roughly 60% across
        path.moveTo(size.width * 0.6 + offset, 0);
        
        path.cubicTo(
          size.width * 0.6 + offset, size.height * 0.1, 
          size.width * 0.9, size.height * 0.15, 
          size.width, size.height * 0.2 + (offset * 0.5)
        );
      }
    } else {
      // Draw waves coming from Bottom-Left Corner
      // ADJUSTED: Curves tighter to the left to avoid the center email text
      for (int i = 0; i < 3; i++) {
        double offset = i * 20.0;
        // Start from left edge, roughly 60% down
        path.moveTo(0, size.height * 0.6 + offset);
        
        path.cubicTo(
          size.width * 0.1, size.height * 0.65 + offset, // Pull control point 1 left
          size.width * 0.25, size.height * 0.8 + offset, // Pull control point 2 left
          size.width * 0.35 + (offset * 0.5), size.height // End point closer to left (Max 35-40% width)
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// --- LOADING ANIMATION ---
class SeesawLoader extends StatefulWidget {
  const SeesawLoader({super.key});

  @override
  State<SeesawLoader> createState() => _SeesawLoaderState();
}

class _SeesawLoaderState extends State<SeesawLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _barRotation;
  late Animation<double> _ballPosition;
  late Animation<double> _ballRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _barRotation = Tween<double>(begin: -0.26, end: 0.26).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _ballPosition = Tween<double>(begin: 150.0, end: -20.0).animate(
       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _ballRotation = Tween<double>(begin: 2 * math.pi, end: 0).animate(
       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: 200, 
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.rotate(
                  angle: _barRotation.value,
                  child: Container(
                    width: 200,
                    height: 12.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAAF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: _ballPosition.value,
                          bottom: 25, 
                          child: Transform.rotate(
                            angle: _ballRotation.value,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 25,
                                    right: 5,
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}