import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A single opaque placeholder block used to compose shimmer skeletons.
///
/// [ShimmerEffect] paints its animated gradient with [BlendMode.srcATop],
/// so every skeleton primitive must be a *solid, opaque* shape for the
/// shimmer to be visible. Keep the fill a light neutral grey.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  /// Base fill color for placeholders. The shimmer gradient is drawn on top.
  static const Color _fill = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _fill,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : (borderRadius ?? BorderRadius.circular(Dimensions.radius15 * 0.5)),
      ),
    );
  }
}

/// A rounded placeholder line, sized like a text run.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    required this.width,
    this.height,
  });

  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height ?? Dimensions.font16 * 0.85,
      borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.4),
    );
  }
}

/// A card-shaped placeholder container that matches the app's card styling
/// (rounded corners + border), with skeleton children inside.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }
}
