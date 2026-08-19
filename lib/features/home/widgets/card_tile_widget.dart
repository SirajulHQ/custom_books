import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const CardTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.iconSize16, color: AppColors.primary),
        SizedBox(width: Dimensions.width10 / 2),
        Text(
          title,
          style: TextStyle(
            fontSize: Dimensions.font16 * 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}