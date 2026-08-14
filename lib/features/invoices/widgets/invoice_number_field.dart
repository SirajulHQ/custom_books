import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class InvoiceNumberField extends StatelessWidget {
  const InvoiceNumberField({
    super.key,
    required this.invoiceNumber,
    required this.onSettingsTap,
  });

  final String invoiceNumber;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Invoice#',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Appcolors.primary,
              ),
            ),
            SizedBox(width: Dimensions.width10 / 3),
            Text(
              '*',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width15,
                  vertical: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Text(
                  invoiceNumber,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: Dimensions.width10),
            GestureDetector(
              onTap: onSettingsTap,
              child: Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: context.colors.surfaceLight,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  size: Dimensions.iconSize24,
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}