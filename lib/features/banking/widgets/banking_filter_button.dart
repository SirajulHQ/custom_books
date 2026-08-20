import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BankingFilterButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const BankingFilterButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Dimensions.iconSize16,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: Dimensions.width10 / 2),
            ],
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: Dimensions.iconSize16,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
