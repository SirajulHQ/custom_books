import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/widgets/status_chip.dart';
import 'package:custom_books/features/vendor_credits/models/vendor_credit_model.dart';
import 'package:flutter/material.dart';

class VendorCreditTile extends StatelessWidget {
  final VendorCreditModel credit;
  final VoidCallback onTap;

  const VendorCreditTile({
    super.key,
    required this.credit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10),
        padding: EdgeInsets.all(Dimensions.width15),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Dimensions.height45 * 0.78,
              height: Dimensions.height45 * 0.78,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                Icons.assignment_return_outlined,
                color: AppColors.primary,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credit.vendorName,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        formatDate(credit.creditDate),
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.7,
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          credit.creditNoteNumber,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  StatusChip(
                    color: credit.status.color,
                    label: credit.status.label,
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Text(
              '₹${credit.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
