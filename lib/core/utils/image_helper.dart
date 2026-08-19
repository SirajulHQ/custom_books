import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:flutter/material.dart';

class ImageHelper {
  /// Determines whether to use NetworkImage or AssetImage based on the image path
  static Widget buildImage(
    String imagePath, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    // Check if the image path is a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: loadingWidget != null
            ? (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingWidget;
              }
            : null,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget
            : (context, error, stackTrace) {
                final colors = Theme.of(context).extension<AppThemeColors>()!;
                return Container(
                  width: width,
                  height: height,
                  color: colors.surfaceLight,
                  child: Icon(
                    Icons.image_not_supported,
                    color: colors.textTertiary,
                  ),
                );
              },
      );
    } else {
      // Use asset image for local assets
      return Image.asset(
        imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget
            : (context, error, stackTrace) {
                final colors = Theme.of(context).extension<AppThemeColors>()!;
                return Container(
                  width: width,
                  height: height,
                  color: colors.surfaceLight,
                  child: Icon(
                    Icons.image_not_supported,
                    color: colors.textTertiary,
                  ),
                );
              },
      );
    }
  }

  /// Returns the appropriate ImageProvider based on the image path
  static ImageProvider getImageProvider(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  /// Checks if the image path is a network URL
  static bool isNetworkImage(String imagePath) {
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }
}
