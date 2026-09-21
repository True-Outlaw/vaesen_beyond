import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';

class WaxSeal extends StatelessWidget {
  final String text;
  final double size;
  final VoidCallback? onTap;

  const WaxSeal({
    super.key,
    this.text = 'V',
    this.size = 48.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        size: Size(size, size * 1.25),
        painter: _WaxSealPainter(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              text,
              style: AppTypography.displayMedium.copyWith(
                fontSize: size * 0.45,
                color: const Color(0xFFF7D5D5),
                fontWeight: FontWeight.bold,
                shadows: [
                  const Shadow(
                    color: Color(0xFF330000),
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaxSealPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;

    // Ribbons
    final ribbonPaint = Paint()
      ..color = const Color(0xFF5C1010)
      ..style = PaintingStyle.fill;

    final pathRibbon1 = Path()
      ..moveTo(center.dx - radius * 0.4, center.dy + radius * 0.5)
      ..lineTo(center.dx - radius * 0.6, size.height)
      ..lineTo(center.dx - radius * 0.2, size.height - 6)
      ..lineTo(center.dx - radius * 0.1, center.dy + radius * 0.6)
      ..close();

    final pathRibbon2 = Path()
      ..moveTo(center.dx + radius * 0.1, center.dy + radius * 0.6)
      ..lineTo(center.dx + radius * 0.3, size.height - 6)
      ..lineTo(center.dx + radius * 0.6, size.height)
      ..lineTo(center.dx + radius * 0.4, center.dy + radius * 0.5)
      ..close();

    canvas.drawPath(pathRibbon1, ribbonPaint);
    canvas.drawPath(pathRibbon2, ribbonPaint);

    // Wax Outer Shadow
    final shadowPaint = Paint()
      ..color = Colors.black45
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center + const Offset(0, 2), radius - 2, shadowPaint);

    // Wax Outer irregular ring
    final waxOuterPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFA82828),
          Color(0xFF7A1616),
          Color(0xFF500A0A),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius - 2, waxOuterPaint);

    // Inner bevel ring
    final ringPaint = Paint()
      ..color = const Color(0xFF6B1212)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius * 0.72, ringPaint);

    // Wax Center
    final innerWaxPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF962020),
          Color(0xFF641010),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.7));
    canvas.drawCircle(center, radius * 0.7, innerWaxPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
