import 'dart:math' as math;
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;

  const LogoWidget({super.key, this.size = 210});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sun rays
          CustomPaint(
            size: Size(size, size),
            painter: _SunRaysPainter(),
          ),
          // Glow circle background
          Container(
            width: size * 0.81,
            height: size * 0.81,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
          ),
          // Graduation cap + leaves
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Icon(
                Icons.school_rounded,
                color: Colors.purple.shade300,
                size: size * 0.38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.4,
                    child: Icon(
                      Icons.eco_rounded,
                      color: Colors.purple.shade200,
                      size: size * 0.155,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Transform.rotate(
                    angle: 0.4,
                    child: Icon(
                      Icons.eco_rounded,
                      color: Colors.purple.shade200,
                      size: size * 0.155,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final innerRadius = size.width * 0.419;
    final outerRadius = size.width * 0.505;
    const rayCount = 12;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount - math.pi / 2;
      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
