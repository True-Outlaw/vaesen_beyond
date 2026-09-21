import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';

/// Reusable investigator portrait widget supporting bundled assets ('assets/...')
/// and custom uploaded images stored as Base64 Data URIs ('data:image/...;base64,...').
/// Compatible with Windows, Android, iOS, and Web.
class GothicPortrait extends StatelessWidget {
  final String portraitAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final String? fallbackInitial;
  final Widget? customPlaceholder;

  const GothicPortrait({
    super.key,
    required this.portraitAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.fallbackInitial,
    this.customPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildRawImage();

    // Clip to specified shape
    if (shape == BoxShape.circle) {
      imageWidget = ClipOval(child: imageWidget);
    } else if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    if (border != null || boxShadow != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          border: border,
          boxShadow: boxShadow,
        ),
        child: imageWidget,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: imageWidget,
    );
  }

  Widget _buildRawImage() {
    final asset = portraitAsset.trim();

    if (asset.isEmpty) {
      return _buildPlaceholder();
    }

    // Custom uploaded image stored as Data URI
    if (asset.startsWith('data:image/')) {
      try {
        final commaIndex = asset.indexOf(',');
        final base64Part = commaIndex != -1 ? asset.substring(commaIndex + 1) : asset;
        final bytes = base64Decode(base64Part.trim());
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } catch (_) {
        return _buildPlaceholder();
      }
    }

    // Bundled asset path
    if (asset.startsWith('assets/')) {
      return Image.asset(
        asset,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // Fallback if plain base64 without data URI prefix
    try {
      final bytes = base64Decode(asset);
      return Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } catch (_) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    if (customPlaceholder != null) return customPlaceholder!;

    return Container(
      width: width,
      height: height,
      color: AppColors.surfaceLight,
      alignment: Alignment.center,
      child: fallbackInitial != null && fallbackInitial!.isNotEmpty
          ? Text(
              fallbackInitial![0].toUpperCase(),
              style: TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: (width != null && width! > 40) ? 20 : 12,
              ),
            )
          : Icon(
              Icons.person,
              color: AppColors.gold.withAlpha(180),
              size: (width != null) ? width! * 0.5 : 24,
            ),
    );
  }
}
