import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback? onTap;

  const FooterButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isDanger,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color neutral = context.colors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: isDanger
              ? AppColors.warn.withValues(alpha: 0.1)
              : neutral.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isDanger
                ? AppColors.warn.withValues(alpha: 0.2)
                : context.colors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize24 * 0.85,
              color: isDanger ? AppColors.warn : neutral,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                fontWeight: FontWeight.w600,
                color: isDanger ? AppColors.warn : neutral,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
