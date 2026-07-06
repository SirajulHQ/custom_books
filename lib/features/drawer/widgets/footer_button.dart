import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';


class FooterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;

  const FooterButton({
    required this.icon,
    required this.label,
    required this.isDanger,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle action
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        decoration: BoxDecoration(
          color: isDanger
              ? Appcolors.warn.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(
            color: isDanger
                ? Appcolors.warn.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: Dimensions.iconSize24 * 0.85,
              color: isDanger ? Appcolors.warn : Colors.black54,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              label,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.7,
                fontWeight: FontWeight.w600,
                color: isDanger ? Appcolors.warn : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
