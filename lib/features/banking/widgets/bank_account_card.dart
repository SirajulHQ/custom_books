import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class BankAccountCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String amount;

  const BankAccountCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.width10),
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.7),
            ),
            child: Icon(icon, color: iconBgColor, size: Dimensions.iconSize24),
          ),
          SizedBox(height: Dimensions.height15),
          Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.75,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Dimensions.height10 / 3),
          Text(
            amount,
            style: TextStyle(
              fontSize: Dimensions.font20 * 0.95,
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
