import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_button.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/core/widgets/wax_seal.dart';

/// Displays the legal and copyright notice in a themed Scandinavian Gothic popup.
Future<void> showLegalDisclaimerDialog(
  BuildContext context, {
  VoidCallback? onAcknowledge,
}) {
  bool acknowledged = false;
  void handleAcknowledge() {
    if (!acknowledged) {
      acknowledged = true;
      onAcknowledge?.call();
    }
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => LegalDisclaimerDialog(
      onAcknowledge: handleAcknowledge,
    ),
  ).then((_) {
    handleAcknowledge();
  });
}

class LegalDisclaimerDialog extends StatelessWidget {
  final VoidCallback? onAcknowledge;

  const LegalDisclaimerDialog({
    super.key,
    this.onAcknowledge,
  });

  void _dismiss(BuildContext context) {
    onAcknowledge?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 680),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(220),
                blurRadius: 28,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: AppColors.gold.withAlpha(30),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
                child: Row(
                  children: [
                    const WaxSeal(text: 'V', size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LEGAL & COPYRIGHT NOTICE',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.goldBright,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'The Society Archives · Upsala Chapter',
                            style: AppTypography.chip.copyWith(
                              color: AppColors.goldDim,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                      tooltip: 'Close notice',
                      onPressed: () => _dismiss(context),
                    ),
                  ],
                ),
              ),

              const OrnateDivider(height: 16),

              // ── Scrollable Body ─────────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Atmospheric Quote / Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2, right: 10),
                              child: Icon(Icons.auto_stories, color: AppColors.goldBright, size: 18),
                            ),
                            Expanded(
                              child: Text(
                                '"In the shadows of the ancient forests and cobblestone alleys of nineteenth-century Scandinavia, those with The Sight uncover mysteries the world prefers to forget."',
                                style: AppTypography.quote.copyWith(
                                  color: AppColors.parchmentMuted,
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Item 1: Free League & Vaesen Copyright
                      _buildNoticeSection(
                        icon: Icons.menu_book,
                        iconColor: AppColors.goldBright,
                        title: 'Vaesen – Nordic Horror Roleplaying',
                        content:
                            'Vaesen – Nordic Horror Roleplaying is copyright © Fria Ligan AB (Free League Publishing). All rights reserved.',
                      ),
                      const SizedBox(height: 10),

                      // Item 2: Johan Egerkrans
                      _buildNoticeSection(
                        icon: Icons.brush_outlined,
                        iconColor: AppColors.gold,
                        title: 'Original Work & Concept',
                        content:
                            'Vaesen is based on the illustrated book "Vaesen: Spirits and Monsters of Scandinavian Folklore" by acclaimed author and illustrator Johan Egerkrans.',
                      ),
                      const SizedBox(height: 10),

                      // Item 3: Unofficial Fan Companion
                      _buildNoticeSection(
                        icon: Icons.shield_outlined,
                        iconColor: AppColors.crimsonBright,
                        title: 'Unofficial Fan Companion',
                        content:
                            'Vaesen Beyond is an unofficial, non-commercial fan-made companion application created for personal tabletop play in accordance with Free League\'s community and workshop guidelines.\n\nThis project is not affiliated with, endorsed, sponsored, or specifically approved by Fria Ligan AB or Johan Egerkrans.',
                      ),
                      const SizedBox(height: 10),

                      // Item 4: Rules & Year Zero Engine
                      _buildNoticeSection(
                        icon: Icons.casino_outlined,
                        iconColor: AppColors.goldBright,
                        title: 'Year Zero Engine',
                        content:
                            'All game mechanics, skill structures, condition tracking, and rules references are based on the Year Zero Engine by Free League Publishing.',
                      ),
                      const SizedBox(height: 10),

                      // Item 5: Offline Privacy
                      _buildNoticeSection(
                        icon: Icons.lock_outline,
                        iconColor: AppColors.emerald,
                        title: '100% Offline & Private',
                        content:
                            'All investigator dossiers, Castle Gyllencreutz headquarters progress, and session notes are stored strictly on your local device. No telemetry, account requirements, or remote data collection.',
                      ),
                    ],
                  ),
                ),
              ),

              const OrnateDivider(height: 16),

              // ── Footer Action Button ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: GothicButton(
                        label: 'I UNDERSTAND & ENTER SOCIETY',
                        icon: Icons.check_circle_outline,
                        color: AppColors.gold,
                        textColor: Colors.black,
                        onPressed: () => _dismiss(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: iconColor.withAlpha(80), width: 0.8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.goldBright,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
