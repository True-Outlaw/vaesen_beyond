import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/conditions_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class ConditionArcHud extends StatefulWidget {
  final Character character;
  final PlayViewModel viewModel;
  final DiceRollerViewModel diceViewModel;

  const ConditionArcHud({
    super.key,
    required this.character,
    required this.viewModel,
    required this.diceViewModel,
  });

  @override
  State<ConditionArcHud> createState() => _ConditionArcHudState();
}

class _ConditionArcHudState extends State<ConditionArcHud> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _pulseController.repeat(reverse: true);
    }
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getPortraitAsset(Character character) {
    final lower = character.archetypeName.toLowerCase();
    if (lower.contains('doctor')) return 'assets/images/portraits/astrid.jpg';
    if (lower.contains('officer')) return 'assets/images/portraits/birger.jpg';
    if (lower.contains('occultist')) return 'assets/images/portraits/elias.jpg';
    if (lower.contains('hunter')) return 'assets/images/portraits/johan.jpg';
    final portraits = [
      'assets/images/portraits/astrid.jpg',
      'assets/images/portraits/birger.jpg',
      'assets/images/portraits/elias.jpg',
      'assets/images/portraits/johan.jpg',
    ];
    return portraits[character.id.hashCode.abs() % portraits.length];
  }

  int _getEquippedArmorProtection(Character character) {
    for (final armor in character.armor) {
      if (armor.isEquipped) return armor.protection;
    }
    return 0;
  }

  void _rollArmor() {
    final activeCharacter = widget.viewModel.activeCharacter ?? widget.character;
    final protection = _getEquippedArmorProtection(activeCharacter);
    if (protection <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No equipped armor to absorb damage.'),
          backgroundColor: AppColors.surfaceOverlay,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    widget.diceViewModel.rollCustomPool(
      poolSize: protection,
      title: 'Armor Protection Roll',
      breakdown: 'Rolling $protection Armor dice. Each 6 absorbs 1 damage.',
    );
    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: widget.diceViewModel,
        playViewModel: widget.viewModel,
      ),
    );
  }

  void _openConditionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final activeChar = widget.viewModel.activeCharacter ?? widget.character;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConditionsCard(character: activeChar, viewModel: widget.viewModel),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final activeCharacter = widget.viewModel.activeCharacter ?? widget.character;
        final conditions = activeCharacter.conditions;
        final isBroken = conditions.isBroken;
        final physPenalty = conditions.physicalPenalty;
        final mntPenalty = conditions.mentalPenalty;
        final armorProt = _getEquippedArmorProtection(activeCharacter);

        // Lethal injuries — untreated
        final lethalInjuries = activeCharacter.activeInjuries
            .where((i) => i.injury.isLethal && !i.isTreated)
            .toList();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: Archetype & Name identity pod
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeCharacter.name,
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.goldBright,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.gold.withAlpha(60), width: 0.6),
                              ),
                              child: Text(
                                activeCharacter.archetypeName.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.gold,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AGE ${activeCharacter.actualAge}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Center: Circular Portrait with 6-segment Condition Arc Ring
                  GestureDetector(
                    onTap: _openConditionsSheet,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _ConditionArcPainter(
                            conditions: conditions,
                            isBroken: isBroken,
                            pulseValue: isBroken ? _pulseAnimation.value : 0.0,
                          ),
                          child: Container(
                            width: 76,
                            height: 76,
                            padding: const EdgeInsets.all(7),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isBroken
                                      ? AppColors.crimson.withAlpha((180 + (75 * _pulseAnimation.value)).toInt())
                                      : AppColors.gold.withAlpha(160),
                                  width: 1.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isBroken
                                        ? AppColors.crimson.withAlpha(120)
                                        : Colors.black.withAlpha(140),
                                    blurRadius: isBroken ? 12 : 6,
                                    spreadRadius: isBroken ? 2 : 0,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  _getPortraitAsset(activeCharacter),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: AppColors.surfaceLight,
                                    child: const Icon(Icons.person, color: AppColors.gold, size: 32),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Right: Armor Shield & Active Condition Banner
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Floating Armor Shield (Tap to roll armor protection)
                        GestureDetector(
                          onTap: _rollArmor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.gold.withAlpha(120), width: 0.8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shield_outlined, color: AppColors.goldBright, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '$armorProt ARMOR',
                                  style: AppTypography.statValue.copyWith(
                                    fontSize: 10,
                                    color: AppColors.goldBright,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Active Condition Status Badge (Tap to manage conditions)
                        GestureDetector(
                          onTap: _openConditionsSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: isBroken
                                  ? AppColors.crimsonDark
                                  : (physPenalty > 0 || mntPenalty > 0)
                                      ? AppColors.surfaceOverlay
                                      : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isBroken
                                    ? AppColors.crimson
                                    : (physPenalty > 0 || mntPenalty > 0)
                                        ? AppColors.crimson.withAlpha(160)
                                        : AppColors.border,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              isBroken
                                  ? 'BROKEN'
                                  : (physPenalty > 0 || mntPenalty > 0)
                                      ? '-${physPenalty + mntPenalty} PENALTY'
                                      : 'UNHARMED',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 9,
                                color: isBroken
                                    ? Colors.white
                                    : (physPenalty > 0 || mntPenalty > 0)
                                        ? AppColors.crimsonBright
                                        : AppColors.textMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Lethal Injury Alert Banner ──────────────────────────────────
            if (lethalInjuries.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.lethal.withAlpha(28),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.lethal.withAlpha(180), width: 1.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: AppColors.lethal, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        lethalInjuries.length == 1
                            ? 'LETHAL: ${lethalInjuries.first.injury.name} — treat within ${lethalInjuries.first.injury.timeLimit}'
                            : '${lethalInjuries.length} LETHAL INJURIES — immediate treatment required!',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.lethal,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ConditionArcPainter extends CustomPainter {
  final ConditionsState conditions;
  final bool isBroken;
  final double pulseValue;

  _ConditionArcPainter({
    required this.conditions,
    required this.isBroken,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 2;

    // We draw 6 arcs spanning 250 degrees total (from 145° to 395° / 35°)
    // Left 3 Arcs: Physical Conditions (start from bottom-left and sweep up to top-left)
    //   Index 0 (bottom-left): Exhausted
    //   Index 1 (mid-left):    Battered
    //   Index 2 (top-left):    Wounded
    // Right 3 Arcs: Mental Conditions (start from bottom-right and sweep up to top-right)
    //   Index 5 (bottom-right): Angry
    //   Index 4 (mid-right):    Frightened
    //   Index 3 (top-right):    Hopeless
    const double gapDegrees = 5.0;
    const double totalSweep = 250.0;
    const double arcSweep = (totalSweep - (5 * gapDegrees)) / 6;
    const double startAngleDeg = 145.0;

    final conditionBools = [
      conditions.exhausted,  // i = 0: bottom-left
      conditions.battered,   // i = 1: mid-left
      conditions.wounded,    // i = 2: top-left
      conditions.hopeless,   // i = 3: top-right
      conditions.frightened, // i = 4: mid-right
      conditions.angry,      // i = 5: bottom-right
    ];

    for (int i = 0; i < 6; i++) {
      final isActive = conditionBools[i];
      final isPhysical = i < 3;
      final isSideBroken = isPhysical ? conditions.brokenPhysical : conditions.brokenMental;
      final startDeg = startAngleDeg + (i * (arcSweep + gapDegrees));
      final startRad = startDeg * (math.pi / 180);
      final sweepRad = arcSweep * (math.pi / 180);

      final color = (isActive || isSideBroken)
          ? (isPhysical
              ? (isSideBroken
                  ? AppColors.crimson.withAlpha((200 + (55 * pulseValue)).toInt())
                  : AppColors.crimson)
              : (isSideBroken
                  ? AppColors.violet.withAlpha((200 + (55 * pulseValue)).toInt())
                  : AppColors.violet))
          : AppColors.surfaceLight.withAlpha(90);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = (isActive || isSideBroken) ? 3.5 : 2.0
        ..strokeCap = StrokeCap.round;

      if (isActive || isSideBroken) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 1.5);
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRad,
        sweepRad,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConditionArcPainter oldDelegate) {
    return oldDelegate.conditions != conditions ||
        oldDelegate.isBroken != isBroken ||
        oldDelegate.pulseValue != pulseValue;
  }
}
