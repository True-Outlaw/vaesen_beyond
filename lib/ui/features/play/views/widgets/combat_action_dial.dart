import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dial_painter.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/fear_test_dialog.dart';

class CombatActionDial extends StatefulWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const CombatActionDial({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  State<CombatActionDial> createState() => _CombatActionDialState();
}

class _CombatActionDialState extends State<CombatActionDial> with TickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _selectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _selectionAnimation = CurvedAnimation(parent: _selectionController, curve: Curves.easeOutCubic);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _pulseController.repeat(reverse: true);
    }
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _selectionController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, double dialSize) {
    final center = Offset(dialSize / 2, dialSize / 2);
    final touch = details.localPosition;
    final dx = touch.dx - center.dx;
    final dy = touch.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final outerRadius = (dialSize / 2) - 8;
    final innerRadius = outerRadius * 0.44;

    HapticFeedback.lightImpact();

    // 1. Center Talisman D6 Touch
    if (distance <= innerRadius) {
      _openCenterDiceRoller();
      return;
    }

    // 2. Dial Chamber Wedge Touch
    if (distance <= outerRadius) {
      double angle = math.atan2(dy, dx);
      if (angle < 0) angle += 2 * math.pi;

      // Find closest chamber center angle
      int bestIndex = 0;
      double minDiff = 100.0;

      for (int i = 0; i < DialPainter.chambers.length; i++) {
        double chamberAngle = DialPainter.chambers[i].centerAngleRad;
        if (chamberAngle < 0) chamberAngle += 2 * math.pi;

        double diff = (angle - chamberAngle).abs();
        if (diff > math.pi) diff = (2 * math.pi) - diff;

        if (diff < minDiff) {
          minDiff = diff;
          bestIndex = i;
        }
      }

      setState(() {
        _selectedIndex = bestIndex;
      });
      _selectionController.forward(from: 0.0);

      _handleChamberAction(bestIndex);
    }
  }

  void _openCenterDiceRoller() {
    widget.diceViewModel.rollCustomPool(
      poolSize: widget.character.getEffectiveAttribute(AttributeType.logic),
      title: 'Society Talisman D6',
      breakdown: 'Free tabletop dice pool builder.',
    );
    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: widget.diceViewModel,
        playViewModel: widget.playViewModel,
      ),
    );
  }

  void _handleChamberAction(int chamberIndex) {
    final chamber = DialPainter.chambers[chamberIndex];

    // Chamber 0: Fear & Horror
    if (chamberIndex == 0) {
      showDialog(
        context: context,
        builder: (_) => FearTestDialog(
          character: widget.character,
          viewModel: widget.playViewModel,
        ),
      );
      return;
    }

    // Chamber 3: Talents
    if (chamberIndex == 3) {
      _showTalentsSheet();
      return;
    }

    // Chambers 1, 2, 4, 5: Attributes (Precision, Logic, Empathy, Physique)
    if (chamber.attribute != null) {
      _showAttributeSkillsSheet(chamber.attribute!);
    }
  }

  void _showTalentsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.goldBright, size: 20),
                const SizedBox(width: 8),
                Text('INVESTIGATOR TALENTS', style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.character.talents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('No talents currently acquired.', style: AppTypography.bodyMedium),
              )
            else
              ...widget.character.talents.map(
                (t) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldDim.withAlpha(90), width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(t.effect, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAttributeSkillsSheet(AttributeType attribute) {
    final attrPool = widget.character.getEffectiveAttribute(attribute);
    final rawAttrVal = widget.character.attributes[attribute] ?? 1;
    final isPhysical = attribute.isPhysical;
    final penalty = isPhysical
        ? widget.character.conditions.physicalPenalty
        : widget.character.conditions.mentalPenalty;

    // Filter the 3 skills belonging to this attribute
    final skills = SkillType.values.where((s) => s.attribute == attribute).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Attribute Name + Penalty
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isPhysical ? Icons.fitness_center : Icons.psychology,
                      color: AppColors.goldBright,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      attribute.label.toUpperCase(),
                      style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright, letterSpacing: 1.2),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.gold.withAlpha(120), width: 0.8),
                  ),
                  child: Text(
                    'Score: $rawAttrVal${penalty > 0 ? " (-$penalty)" : ""}',
                    style: AppTypography.labelSmall.copyWith(
                      color: penalty > 0 ? AppColors.crimsonBright : AppColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              attribute.description,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 14),

            // 3 Skills Cards with 1-Tap Roll buttons
            ...skills.map((skill) {
              final skillLevel = widget.character.skills[skill] ?? 0;
              final effectivePool = widget.character.getEffectiveSkill(skill);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                skill.label,
                                style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.textPrimary),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(Rank $skillLevel)',
                                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            skill.description,
                            style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.diceViewModel.rollSkill(
                          character: widget.character,
                          skill: skill,
                        );
                        showDialog(
                          context: context,
                          builder: (_) => DiceTrayDialog(
                            diceViewModel: widget.diceViewModel,
                            playViewModel: widget.playViewModel,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceOverlay,
                        foregroundColor: AppColors.goldBright,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: AppColors.gold.withAlpha(160), width: 0.8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$effectivePool D6',
                            style: AppTypography.statValue.copyWith(fontSize: 11, color: AppColors.goldBright),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.casino_outlined, size: 14, color: AppColors.goldBright),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 6),

            // Raw Attribute Roll Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.diceViewModel.rollAttribute(
                    character: widget.character,
                    attribute: attribute,
                  );
                  showDialog(
                    context: context,
                    builder: (_) => DiceTrayDialog(
                      diceViewModel: widget.diceViewModel,
                      playViewModel: widget.playViewModel,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.gold,
                  side: BorderSide(color: AppColors.gold.withAlpha(120), width: 0.8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.casino, size: 16),
                label: Text(
                  'ROLL RAW ${attribute.label.toUpperCase()} ($attrPool D6)',
                  style: AppTypography.tabLabel.copyWith(fontSize: 11, letterSpacing: 1.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDialSize = math.min(constraints.maxWidth - 24, 330.0);

        return Center(
          child: SizedBox(
            width: maxDialSize,
            height: maxDialSize,
            child: GestureDetector(
              onTapDown: (details) => _onTapDown(details, maxDialSize),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Custom Painted Obsidian Dial
                  AnimatedBuilder(
                    animation: Listenable.merge([_selectionAnimation, _pulseAnimation]),
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(maxDialSize, maxDialSize),
                        painter: DialPainter(
                          character: widget.character,
                          selectedIndex: _selectedIndex,
                          selectionProgress: _selectionAnimation.value,
                          pulseValue: _pulseAnimation.value,
                        ),
                      );
                    },
                  ),

                  // 2. Centerpiece: The Society Talisman D6
                  IgnorePointer(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2CE8C5).withAlpha(60),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_in_ar,
                            color: AppColors.goldBright,
                            size: 24,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF2CE8C5).withAlpha(180),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'D6',
                            style: AppTypography.statValue.copyWith(
                              fontSize: 10,
                              color: AppColors.goldBright,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
