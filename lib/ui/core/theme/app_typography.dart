import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Vaesen Beyond typography hierarchy — D&D Beyond-inspired role separation.
///
/// Roles:
///  - **Display** `Cinzel` → Character name, section headers (gothic authority)
///  - **Stat** `Cinzel` bold + oversized → Dice pool numbers, damage values
///  - **Tag / Chip** `Inter` tight uppercase → Badges, range chips, status pills
///  - **UI Button** `Inter` medium → Action button labels, tab labels
///  - **Body** `Spectral` → Lore text, descriptions, flavor
///  - **Quote** `Cormorant Garamond` italic → Atmospheric flavor quotes
class AppTypography {
  // ── Display — Gothic Headings (Cinzel) ─────────────────────────────────

  static TextStyle get displayLarge => GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
        letterSpacing: 2.0,
      );

  static TextStyle get displayMedium => GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 1.5,
      );

  static TextStyle get titleLarge => GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.goldBright,
        letterSpacing: 1.2,
      );

  static TextStyle get titleMedium => GoogleFonts.cinzel(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.8,
      );

  static TextStyle get titleSmall => GoogleFonts.cinzel(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.gold,
        letterSpacing: 0.5,
      );

  // ── Stat Numbers — Big Bold Condensed (Cinzel bold + color) ────────────

  /// Used for large attribute values on stat pods (4, 3, etc.)
  static TextStyle get statHero => GoogleFonts.cinzel(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.goldBright,
        height: 1.0,
      );

  /// Used for dice pool numbers on dual-capsule action pills
  static TextStyle get statDicePool => GoogleFonts.cinzel(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.goldBright,
        letterSpacing: 0.2,
      );

  static TextStyle get statNumber => GoogleFonts.cinzel(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.goldBright,
      );

  // ── UI Tag / Chip Labels (Inter — tight uppercase) ──────────────────────

  /// Range chips, quality badges, condition tags
  static TextStyle get chip => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.8,
      );

  /// Section sub-labels and status indicators
  static TextStyle get label => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle get statValue => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.goldBright,
        letterSpacing: 0.5,
      );

  /// Tab bar labels and nav controls
  static TextStyle get tabLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.6,
      );

  /// Primary action button text
  static TextStyle get actionButton => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  // ── Body — Atmospheric Lore (Spectral) ──────────────────────────────────

  static TextStyle get bodyLarge => GoogleFonts.spectral(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.spectral(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.35,
      );

  static TextStyle get bodySmall => GoogleFonts.spectral(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // ── Atmospheric Quotes (Cormorant Garamond) ──────────────────────────────

  static TextStyle get quote => GoogleFonts.cormorantGaramond(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: AppColors.textPrimary,
      );
}
