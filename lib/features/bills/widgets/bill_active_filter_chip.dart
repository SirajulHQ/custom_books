import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BillActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const BillActiveFilterChip({
    super.key,
    required this.label,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimensions.width20,
        0,
        Dimensions.width20,
        Dimensions.height10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height10 / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt_rounded,
            size: Dimensions.iconSize16,
            color: AppColors.primary,
          ),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            'Status: $label',
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.72,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onClear,
            child: Icon(
              Icons.close_rounded,
              size: Dimensions.iconSize16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
