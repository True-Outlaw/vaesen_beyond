import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';

/// Reusable gothic-styled action button with gold/crimson filigree accents.
class GothicButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;

  const GothicButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.color,
    this.textColor,
    this.padding,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? AppColors.gold;

    if (isOutlined) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: baseColor,
          side: BorderSide(color: baseColor, width: 1.2),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        child: _buildChild(baseColor),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: baseColor,
        foregroundColor: textColor ?? Colors.black,
        elevation: 3,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: baseColor.withAlpha(200), width: 1),
        ),
      ),
      onPressed: onPressed,
      child: _buildChild(textColor ?? Colors.black),
    );
  }

  Widget _buildChild(Color fgColor) {
    if (icon == null) {
      return Text(
        label,
        style: AppTypography.actionButton.copyWith(
          color: fgColor,
          letterSpacing: 0.8,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: fgColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.actionButton.copyWith(
            color: fgColor,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
