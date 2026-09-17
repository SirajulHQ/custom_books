import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final Color color;
  final String label;

  const StatusChip({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10 * 0.2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.6,
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
