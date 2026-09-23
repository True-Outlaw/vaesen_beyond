import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';

class DialChamberInfo {
  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final AttributeType? attribute;
  final double centerAngleRad; // Center angle in radians

  const DialChamberInfo({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.attribute,
    required this.centerAngleRad,
  });
}

class DialPainter extends CustomPainter {
  final Character character;
  final int? selectedIndex;
  final double selectionProgress;
  final double pulseValue;

  DialPainter({
    required this.character,
    this.selectedIndex,
    required this.selectionProgress,
    required this.pulseValue,
  });

  static final List<DialChamberInfo> chambers = [
    DialChamberInfo(
      index: 0,
      title: 'FEAR & HORROR',
      subtitle: 'Fear Test & Panic',
      icon: Icons.visibility,
      attribute: null,
      centerAngleRad: 270 * (math.pi / 180), // Top
    ),
    DialChamberInfo(
      index: 1,
      title: 'PRECISION',
      subtitle: 'Medicine • Ranged • Stealth',
      icon: Icons.gps_fixed,
      attribute: AttributeType.precision,
      centerAngleRad: 330 * (math.pi / 180), // Top-Right
    ),
    DialChamberInfo(
      index: 2,
      title: 'LOGIC',
      subtitle: 'Investigate • Learn • Vigil',
      icon: Icons.menu_book,
      attribute: AttributeType.logic,
      centerAngleRad: 30 * (math.pi / 180), // Bottom-Right
    ),
    DialChamberInfo(
      index: 3,
      title: 'TALENTS',
      subtitle: 'Archetype Powers',
      icon: Icons.auto_awesome,
      attribute: null,
      centerAngleRad: 90 * (math.pi / 180), // Bottom
    ),
    DialChamberInfo(
      index: 4,
      title: 'EMPATHY',
      subtitle: 'Inspire • Manipulate • Observe',
      icon: Icons.favorite_border,
      attribute: AttributeType.empathy,
      centerAngleRad: 150 * (math.pi / 180), // Bottom-Left
    ),
    DialChamberInfo(
      index: 5,
      title: 'PHYSIQUE',
      subtitle: 'Agility • Close Combat • Force',
      icon: Icons.fitness_center,
      attribute: AttributeType.physique,
      centerAngleRad: 210 * (math.pi / 180), // Top-Left
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (size.width / 2) - 8;
    final innerRadius = outerRadius * 0.44;

    const double gapRad = 2.5 * (math.pi / 180);
    const double chamberSweep = (2 * math.pi / 6) - gapRad;

    // 1. Draw 6 Sculpted Obsidian Wedges
    for (int i = 0; i < 6; i++) {
      final chamber = chambers[i];
      final isSelected = selectedIndex == i;
      final startAngle = (chamber.centerAngleRad - (chamberSweep / 2));

      // Calculate radial translation when selected
      final double radialOffset = isSelected ? (selectionProgress * 6.0) : 0.0;
      final Offset wedgeCenter = center +
          Offset(
            math.cos(chamber.centerAngleRad) * radialOffset,
            math.sin(chamber.centerAngleRad) * radialOffset,
          );

      // Construct wedge path
      final Path path = Path();
      path.arcTo(
        Rect.fromCircle(center: wedgeCenter, radius: outerRadius),
        startAngle,
        chamberSweep,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: wedgeCenter, radius: innerRadius),
        startAngle + chamberSweep,
        -chamberSweep,
        false,
      );
      path.close();

      // Background fill paint
      final Paint fillPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment(
            math.cos(chamber.centerAngleRad) * 0.5,
            math.sin(chamber.centerAngleRad) * 0.5,
          ),
          radius: 1.0,
          colors: isSelected
              ? [const Color(0xFF2E3942), const Color(0xFF182026)]
              : [const Color(0xFF1B2228), const Color(0xFF101519)],
        ).createShader(Rect.fromCircle(center: wedgeCenter, radius: outerRadius));

      canvas.drawPath(path, fillPaint);

      // Border outline paint
      final Paint borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.0 : 1.0
        ..color = isSelected
            ? AppColors.goldBright
            : AppColors.gold.withAlpha(140);

      canvas.drawPath(path, borderPaint);

      // Draw outer node circle along wedge perimeter
      final nodeCenter = wedgeCenter +
          Offset(
            math.cos(chamber.centerAngleRad) * (outerRadius - 1),
            math.sin(chamber.centerAngleRad) * (outerRadius - 1),
          );

      final Paint nodeBgPaint = Paint()
        ..color = isSelected ? AppColors.surfaceLight : AppColors.surface
        ..style = PaintingStyle.fill;
      canvas.drawCircle(nodeCenter, 10, nodeBgPaint);

      final Paint nodeBorderPaint = Paint()
        ..color = isSelected ? AppColors.goldBright : AppColors.gold.withAlpha(160)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(nodeCenter, 10, nodeBorderPaint);

      // Draw chamber label & pool badge
      _drawChamberText(
        canvas: canvas,
        center: wedgeCenter,
        chamber: chamber,
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        isSelected: isSelected,
      );
    }

    // 2. Draw Center Cavity & Recessed Brass Bezel
    final Paint glowPaint = Paint()
      ..color = const Color(0xFF2CE8C5).withAlpha((30 + (25 * pulseValue)).toInt())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    canvas.drawCircle(center, innerRadius + 2, glowPaint);

    final Paint cavityBgPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF131A1E),
          Color(0xFF090D0F),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));
    canvas.drawCircle(center, innerRadius - 1, cavityBgPaint);

    // Bezel rings
    final Paint bezelPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.gold.withAlpha(200);
    canvas.drawCircle(center, innerRadius - 1, bezelPaint);

    final Paint innerBezelPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = AppColors.goldBright.withAlpha(120);
    canvas.drawCircle(center, innerRadius - 5, innerBezelPaint);
  }

  void _drawChamberText({
    required Canvas canvas,
    required Offset center,
    required DialChamberInfo chamber,
    required double innerRadius,
    required double outerRadius,
    required bool isSelected,
  }) {
    // Label position sits midway along the wedge radial arm
    final double textRadius = (innerRadius + outerRadius) / 2;
    final Offset textPos = center +
        Offset(
          math.cos(chamber.centerAngleRad) * textRadius,
          math.sin(chamber.centerAngleRad) * textRadius,
        );

    String poolText = '';
    if (chamber.attribute != null) {
      final pool = character.getEffectiveAttribute(chamber.attribute!);
      poolText = '$pool D6';
    }

    final double fontScale = (outerRadius / 157.0).clamp(0.85, 1.45);

    // Measure and draw title
    final TextSpan titleSpan = TextSpan(
      text: chamber.title,
      style: TextStyle(
        fontFamily: 'Cinzel',
        fontSize: (10 * fontScale).roundToDouble(),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: isSelected ? AppColors.goldBright : Colors.white.withAlpha(230),
      ),
    );
    final TextPainter tpTitle = TextPainter(
      text: titleSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    tpTitle.paint(
      canvas,
      textPos - Offset(tpTitle.width / 2, tpTitle.height / 2 + (poolText.isNotEmpty ? 6 * fontScale : 0)),
    );

    // Draw pool badge if attribute
    if (poolText.isNotEmpty) {
      final TextSpan poolSpan = TextSpan(
        text: poolText,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: (9 * fontScale).roundToDouble(),
          fontWeight: FontWeight.w700,
          color: isSelected ? AppColors.goldBright : AppColors.goldDim,
        ),
      );
      final TextPainter tpPool = TextPainter(
        text: poolSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      tpPool.paint(
        canvas,
        textPos - Offset(tpPool.width / 2, -4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DialPainter oldDelegate) {
    return oldDelegate.character != character ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.selectionProgress != selectionProgress ||
        oldDelegate.pulseValue != pulseValue;
  }
}
