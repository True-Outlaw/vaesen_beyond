import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Helper utility for adaptive breakpoints across Mobile, Tablet, Desktop and Web.
class Responsive {
  static const double mobileBreakpoint = 1180.0;
  static const double maxContentWidth = 1500.0;

  /// Returns true if the screen width is wide enough for the multi-column desktop/web layout.
  static bool isWide(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= mobileBreakpoint;
  }

  /// Returns true if running on a desktop platform or web.
  static bool isDesktopOrWeb() {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }
}
