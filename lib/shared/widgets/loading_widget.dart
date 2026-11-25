import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends StatefulWidget {
  final String? message;
  final String? subMessage;
  final IconData icon;

  const LoadingWidget({
    super.key,
    this.message,
    this.subMessage,
    this.icon = Icons.explore_rounded,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Spinning Gradient Ring
                RotationTransition(
                  turns: _spinController,
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          const Color(0xFFD96C2C).withValues(alpha: 0.1),
                          const Color(0xFFD96C2C),
                          const Color(0xFFE9C46A),
                          const Color(0xFFD96C2C).withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7F0E6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Inner Pulsing Badge Icon
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD96C2C), Color(0xFFC45A1B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFD96C2C,
                          ).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 32),
                  ),
                ),
              ],
            ),
            if (widget.message != null || widget.subMessage != null) ...[
              const SizedBox(height: 18),
              if (widget.message != null)
                Text(
                  widget.message!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF332820),
                    letterSpacing: 0.3,
                  ),
                ),
              if (widget.subMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.krub(
                    fontSize: 12,
                    color: const Color(0xFF786B62),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
