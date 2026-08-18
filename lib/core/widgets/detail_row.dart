import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.78,
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: Dimensions.width10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.88,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
