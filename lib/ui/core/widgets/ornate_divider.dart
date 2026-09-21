import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';

class OrnateDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const OrnateDivider({
    super.key,
    this.height = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppColors.goldDim;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor.withAlpha(0),
                    dividerColor.withAlpha(180),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dividerColor,
                  border: Border.all(color: AppColors.goldBright, width: 0.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor.withAlpha(180),
                    dividerColor.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
