import 'package:flutter/material.dart';

/// Vaesen Beyond color system — D&D Beyond-inspired tiered slate obsidian surfaces
/// blended with authentic Scandinavian gothic accents.
class AppColors {
  // ── Tiered Slate Obsidian Surfaces ──────────────────────────────────────
  /// Deepest page backdrop
  static const Color background = Color(0xFF0E1215);

  /// Base elevated card surface
  static const Color surface = Color(0xFF181E23);

  /// Mid-elevation surface (nested panels, rows)
  static const Color surfaceLight = Color(0xFF222A31);

  /// High-elevation interactive element / overlay
  static const Color surfaceOverlay = Color(0xFF2C3640);

  /// Subtle structural borders (replaces gaudy 1px gold lines on everything)
  static const Color border = Color(0xFF2C363F);

  /// Barely-visible divider lines inside cards
  static const Color divider = Color(0xFF1F2830);

  // ── Parchment & Document Surfaces ───────────────────────────────────────
  static const Color parchment = Color(0xFFF3ECDF);
  static const Color parchmentMuted = Color(0xFFE4DAC7);
  static const Color parchmentDark = Color(0xFF242E35);

  // ── Gold Accent Hierarchy ────────────────────────────────────────────────
  /// Primary warm parchment gold — character name, key icons
  static const Color gold = Color(0xFFE5C378);

  /// Bright gold — active indicators, selected tabs, dice pool numbers
  static const Color goldBright = Color(0xFFF2D68F);

  /// Dim gold — borders, muted decorations
  static const Color goldDim = Color(0xFF8D713C);

  /// Deepest gold background tint — pill backgrounds
  static const Color goldSubtle = Color(0xFF2A2218);

  // ── Blood Crimson — Health / Physical Damage ─────────────────────────────
  static const Color crimson = Color(0xFFC82333);
  static const Color crimsonBright = Color(0xFFFF4D4D);
  static const Color crimsonDark = Color(0xFF5A0D15);
  static const Color crimsonLight = Color(0xFFE53545);
  static const Color crimsonGaze = Color(0xFF3D0A10);
  static const Color crimsonSubtle = Color(0xFF2A1215);
  static const Color lethal = Color(0xFFFF4444);
  static const Color backgroundDark = Color(0xFF0A0D0F);

  // ── Sanity Violet — Mental / Horror ─────────────────────────────────────
  static const Color violet = Color(0xFF8E75C4);
  static const Color violetLight = Color(0xFFA891D6);
  static const Color violetSubtle = Color(0xFF1E1830);

  // ── Emerald — Success / Healthy ──────────────────────────────────────────
  static const Color emerald = Color(0xFF4EBA6F);
  static const Color emeraldSubtle = Color(0xFF0E2018);

  // ── Typography ──────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFECE5D8);
  static const Color textSecondary = Color(0xFFA6B3BA);
  static const Color textMuted = Color(0xFF6F7E86);
  static const Color textDark = Color(0xFF1E1E1E);

  // ── Conditions & Status ─────────────────────────────────────────────────
  static const Color physicalCondition = Color(0xFFD9534F);
  static const Color mentalCondition = Color(0xFF8E75C4);
  static const Color success = Color(0xFFD4AF37);
}
