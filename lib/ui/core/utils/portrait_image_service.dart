import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';

/// Cross-platform service to pick and process custom investigator portraits.
/// Supports Windows, Android, iOS, and Web.
class PortraitImageService {
  /// Opens the native file picker for images, reads the bytes cross-platform,
  /// resizes/optimizes to [maxDimension], and returns a self-contained Base64 Data URI.
  static Future<String?> pickAndProcessCustomPortrait({int maxDimension = 512}) async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file == null) {
        return null;
      }

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        return null;
      }

      final optimizedBytes = await _resizeImage(bytes, maxDimension: maxDimension);
      final base64String = base64Encode(optimizedBytes);
      return 'data:image/png;base64,$base64String';
    } catch (e) {
      return null;
    }
  }

  /// Scales the image to [maxDimension] preserving aspect ratio and encodes to PNG.
  /// Uses Flutter's built-in `dart:ui.instantiateImageCodec` available on all platforms.
  static Future<Uint8List> _resizeImage(Uint8List rawBytes, {required int maxDimension}) async {
    try {
      final codec = await ui.instantiateImageCodec(
        rawBytes,
        targetWidth: maxDimension,
      );
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (_) {
      // Fall back to original bytes if codec fails on particular raw formats
    }
    return rawBytes;
  }
}
