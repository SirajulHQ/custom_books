import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

/// A shared card widget used by all document-list tiles.
///
/// Parameters that differ per document type:
/// - [leadingIcon] / [leadingColor] — icon box appearance
/// - [primaryText] — customer or vendor name
/// - [date] — formatted document date
/// - [documentNumber] — e.g. "INV-0001", "SO-00309"
/// - [statusWidget] — any chip/badge placed below the date row
/// - [amount] — pre-formatted string, e.g. "₹1,234.00"
/// - [amountColor] — defaults to [AppColors.primary]
/// - [subDate] — optional second date row, e.g. "Due 12 Aug 2026" (Invoice, Bill)
/// - [trailingBadge] — optional extra badge after [statusWidget] (Sales Order)
/// - [onTap] — required tap handler
/// - [onLongPress] — optional long-press handler
class DocumentListTile extends StatelessWidget {
  const DocumentListTile({
    super.key,
    required this.leadingIcon,
    required this.leadingColor,
    required this.primaryText,
    required this.date,
    required this.documentNumber,
    required this.statusWidget,
    required this.amount,
    this.amountColor,
    this.subDate,
    this.trailingBadge,
    required this.onTap,
    this.onLongPress,
  });

  final IconData leadingIcon;
  final Color leadingColor;
  final String primaryText;
  final String date;
  final String documentNumber;
  final Widget statusWidget;
  final String amount;
  final Color? amountColor;

  /// Optional second row shown below the date+number row, e.g. "Due 12 Aug 2026".
  final String? subDate;

  /// Optional widget placed after [statusWidget] in the bottom row.
  final Widget? trailingBadge;

  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = amountColor ?? AppColors.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      onTap: onTap,
      onLongPress: onLongPress,
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
            // ── Leading icon box ──────────────────────────────────────
            Container(
              width: Dimensions.height45 * 0.78,
              height: Dimensions.height45 * 0.78,
              decoration: BoxDecoration(
                color: leadingColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radius15 - 4),
              ),
              child: Icon(
                leadingIcon,
                color: leadingColor,
                size: Dimensions.iconSize24 - 4,
              ),
            ),

            SizedBox(width: Dimensions.width15),

            // ── Middle column ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary text (customer / vendor name)
                  Text(
                    primaryText,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.95,
                      fontWeight: FontWeight.w700,
                      color: context.colors.textPrimary,
                    ),
                  ),

                  SizedBox(height: Dimensions.height10 / 2),

                  // Date + document number row
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: Dimensions.iconSize16 - 2,
                        color: context.colors.textTertiary,
                      ),
                      SizedBox(width: Dimensions.width10 / 2),
                      Text(
                        date,
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
                          documentNumber,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Optional sub-date row (Due date for invoices / bills)
                  if (subDate != null) ...[
                    SizedBox(height: Dimensions.height10 / 2),
                    Row(
                      children: [
                        Icon(
                          Icons.event_busy_rounded,
                          size: Dimensions.iconSize16 - 2,
                          color: context.colors.textTertiary,
                        ),
                        SizedBox(width: Dimensions.width10 / 2),
                        Text(
                          subDate!,
                          style: TextStyle(
                            fontSize: Dimensions.font16 * 0.7,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: Dimensions.height10 / 2),

                  // Status chip row (+ optional trailing badge)
                  Row(
                    children: [
                      statusWidget,
                      if (trailingBadge != null) ...[
                        SizedBox(width: Dimensions.width10 / 2),
                        trailingBadge!,
                      ],
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: Dimensions.width10),

            // ── Trailing amount ───────────────────────────────────────
            Text(
              amount,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.9,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
