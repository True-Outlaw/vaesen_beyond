import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';

class D6DiceWidget extends StatelessWidget {
  final int value;
  final bool isPushed;
  final double size;

  const D6DiceWidget({
    super.key,
    required this.value,
    this.isPushed = false,
    this.size = 48.0,
  });

  bool get isSuccess => value == 6;

  @override
  Widget build(BuildContext context) {
    final bgGradient = isSuccess
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE5C07B), Color(0xFFC5A059), Color(0xFF9E7830)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C3840), Color(0xFF1E262B), Color(0xFF151B1F)],
          );

    final borderColor = isSuccess ? AppColors.goldBright : AppColors.surfaceOverlay;
    final pipColor = isSuccess ? const Color(0xFF1E1E1E) : AppColors.textSecondary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(
          color: borderColor,
          width: isSuccess ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSuccess ? AppColors.gold.withAlpha(160) : Colors.black45,
            blurRadius: isSuccess ? 8 : 4,
            spreadRadius: isSuccess ? 1 : 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: _buildPips(pipColor),
          ),
          if (isSuccess)
            Positioned(
              bottom: 1,
              right: 2,
              child: Text(
                '★',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: size * 0.22,
                  color: const Color(0xFF3B2A08),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPips(Color color) {
    final pipSize = size * 0.16;

    switch (value) {
      case 1:
        return _pip(color, pipSize * 1.3);
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(alignment: const Alignment(-0.6, 0), child: _pip(color, pipSize)),
            Align(alignment: const Alignment(0.6, 0), child: _pip(color, pipSize)),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(alignment: const Alignment(-0.6, 0), child: _pip(color, pipSize)),
            _pip(color, pipSize),
            Align(alignment: const Alignment(0.6, 0), child: _pip(color, pipSize)),
          ],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_pip(color, pipSize), _pip(color, pipSize)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_pip(color, pipSize), _pip(color, pipSize)],
            ),
          ],
        );
      case 5:
        return Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [_pip(color, pipSize), _pip(color, pipSize)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [_pip(color, pipSize), _pip(color, pipSize)],
                ),
              ],
            ),
            Center(child: _pip(color, pipSize)),
          ],
        );
      case 6:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_pip(color, pipSize), _pip(color, pipSize)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_pip(color, pipSize), _pip(color, pipSize)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_pip(color, pipSize), _pip(color, pipSize)],
            ),
          ],
        );
    }
  }

  Widget _pip(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.5, 0.5),
            blurRadius: 1,
          ),
        ],
      ),
    );
  }
}
