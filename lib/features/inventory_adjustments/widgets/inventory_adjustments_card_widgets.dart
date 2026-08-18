import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/date_formatter.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/inventory_adjustments/models/inventory_adjustments_model.dart';
import 'package:flutter/material.dart';

/// Which tab the list is currently showing, so the card knows whether
/// to lead with quantity or value on the right-hand side.
enum AdjustmentListMode { all, byQuantity, byValue }

class InventoryAdjustmentCardWidget extends StatelessWidget {
  final InventoryAdjustment adjustment;
  final AdjustmentListMode mode;
  final VoidCallback? onTap;

  const InventoryAdjustmentCardWidget({
    super.key,
    required this.adjustment,
    required this.mode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDraft = adjustment.status == AdjustmentStatus.draft;
    final isPositive = adjustment.quantityChange >= 0;

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
              width: Dimensions.height45 * 0.75,
              height: Dimensions.height45 * 0.75,
              decoration: BoxDecoration(
                color: (isPositive ? Appcolors.primary : Appcolors.warn)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: isPositive ? Appcolors.primary : Appcolors.warn,
                size: Dimensions.iconSize24 - 4,
              ),
            ),
            SizedBox(width: Dimensions.width15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adjustment.reason,
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
                        formatDate(adjustment.date),
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
                      Icon(
                        Icons.person_outline_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Flexible(
                        child: Text(
                          adjustment.createdBy,
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (isDraft ? Appcolors.warn : Appcolors.primary)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                    ),
                    child: Text(
                      adjustment.status.label,
                      style: TextStyle(
                        fontSize: Dimensions.font16 * 0.6,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: isDraft ? Appcolors.warn : Appcolors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  mode == AdjustmentListMode.byValue
                      ? _formatValue(adjustment.value)
                      : '${isPositive ? '+' : ''}${adjustment.quantityChange}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w800,
                    color: isPositive ? Appcolors.primary : Appcolors.warn,
                  ),
                ),
                if (mode == AdjustmentListMode.all) ...[
                  SizedBox(height: Dimensions.height10 / 2),
                  Text(
                    _formatValue(adjustment.value),
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.65,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(double value) {
    final sign = value < 0 ? '-' : '';
    return '$sign₹${value.abs().toStringAsFixed(2)}';
  }
}
