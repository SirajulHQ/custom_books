import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

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

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color foregroundColor;
  final bool elevated;
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
            blurRadius: Dimensions.radius15 * 1.07,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: fab,
    );
  }
}
