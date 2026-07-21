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
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
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
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
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
