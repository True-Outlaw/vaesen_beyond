import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';

class GothicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool hasGoldCorners;
  final VoidCallback? onTap;

  const GothicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.hasGoldCorners = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? AppColors.surfaceOverlay,
          width: borderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          if (hasGoldCorners) ...[
            const Positioned(
              top: 3,
              left: 3,
              child: _CornerAccent(isTop: true, isLeft: true),
            ),
            const Positioned(
              top: 3,
              right: 3,
              child: _CornerAccent(isTop: true, isLeft: false),
            ),
            const Positioned(
              bottom: 3,
              left: 3,
              child: _CornerAccent(isTop: false, isLeft: true),
            ),
            const Positioned(
              bottom: 3,
              right: 3,
              child: _CornerAccent(isTop: false, isLeft: false),
            ),
          ],
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }
    return content;
  }
}

class _CornerAccent extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _CornerAccent({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.goldDim,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTop && isLeft ? 2 : 0),
          topRight: Radius.circular(isTop && !isLeft ? 2 : 0),
          bottomLeft: Radius.circular(!isTop && isLeft ? 2 : 0),
          bottomRight: Radius.circular(!isTop && !isLeft ? 2 : 0),
        ),
      ),
    );
  }
}
