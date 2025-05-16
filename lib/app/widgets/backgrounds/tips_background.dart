import 'package:flutter/material.dart';

class TipsBackground extends StatelessWidget {
  final Widget child;

  const TipsBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withOpacity(0.05),
            Colors.white,
            colorScheme.surfaceVariant.withOpacity(0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: _buildDecorationCircle(
              size: 200,
              color: colorScheme.primary.withOpacity(0.08),
            ),
          ),
          Positioned(
            top: 50,
            left: -70,
            child: _buildDecorationCircle(
              size: 140,
              color: colorScheme.secondary.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: _buildDecorationCircle(
              size: 160,
              color: colorScheme.tertiary?.withOpacity(0.07) ??
                  colorScheme.primary.withOpacity(0.07),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _buildDecorationCircle(
              size: 120,
              color: colorScheme.primary.withOpacity(0.05),
            ),
          ),
          CustomPaint(
            size: Size.infinite,
            painter: PatternPainter(
              lineColor: colorScheme.primary.withOpacity(0.03),
              density: 0.5,
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget _buildDecorationCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color lineColor;
  final double density;

  PatternPainter({
    required this.lineColor,
    this.density = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = 25.0 / density;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor || oldDelegate.density != density;
}
