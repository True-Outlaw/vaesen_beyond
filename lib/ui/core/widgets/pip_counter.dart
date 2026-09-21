import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';

class PipCounter extends StatelessWidget {
  final int value;
  final int max;
  final int min;
  final ValueChanged<int>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;

  const PipCounter({
    super.key,
    required this.value,
    this.max = 5,
    this.min = 0,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final filledColor = activeColor ?? AppColors.goldBright;
    final emptyColor = inactiveColor ?? AppColors.surfaceOverlay;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        final pipNumber = index + 1;
        final isFilled = pipNumber <= value;

        Widget pip = Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? filledColor : Colors.transparent,
            border: Border.all(
              color: isFilled ? filledColor : emptyColor,
              width: 1.5,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: filledColor.withAlpha(120),
                      blurRadius: 4,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
        );

        if (onChanged != null) {
          pip = InkWell(
            onTap: () {
              int newVal;
              if (value == pipNumber) {
                newVal = (pipNumber - 1).clamp(min, max);
              } else {
                newVal = pipNumber.clamp(min, max);
              }
              onChanged!(newVal);
            },
            customBorder: const CircleBorder(),
            child: pip,
          );
        }

        return pip;
      }),
    );
  }
}
