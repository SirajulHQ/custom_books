import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A reusable Floating Action Button with an optional elevated shadow container.
///
/// By default it shows the elevated style (with primary-colored shadow).
/// Set [elevated] to `false` for a flat FAB without the extra shadow wrapper.
class CustomAddButton extends StatelessWidget {
  const CustomAddButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.add_rounded,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.elevated = true,
    this.tooltip,
  });

  /// Callback when the FAB is tapped.
  final VoidCallback onPressed;

  /// Icon displayed inside the FAB. Defaults to [Icons.add_rounded].
  final IconData icon;

  /// Background color of the FAB. Defaults to [Appcolors.primary].
  final Color? backgroundColor;

  /// Icon color. Defaults to white.
  final Color foregroundColor;

  /// Whether to wrap the FAB in a container with an elevated shadow.
  /// Most pages use the elevated style.
  final bool elevated;

  /// Optional tooltip for accessibility.
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Appcolors.primary;

    final fab = FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bgColor,
      foregroundColor: foregroundColor,
      tooltip: tooltip,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Icon(icon),
    );

    if (!elevated) return fab;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: fab,
    );
  }
}
