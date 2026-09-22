import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:custom_books/features/home/widgets/financial_summary_sheet_helpers.dart';
import 'package:flutter/material.dart';

void showPayablesSheet(BuildContext context, FinancialDetail detail) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PayablesSheet(detail: detail),
  );
}

class PayablesSheet extends StatelessWidget {
  final FinancialDetail detail;

  const PayablesSheet({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius20 * 1.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetDragHandle(),

          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              0,
              Dimensions.width20,
              Dimensions.height15,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.width10 * 0.7),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_made_rounded,
                    color: AppColors.accent,
                    size: Dimensions.iconSize22,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Total Payables',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: context.colors.border),
          SizedBox(height: Dimensions.height20),

          // ── Summary card ───────────────────────────────────────────────
          FinancialSummaryCard(
            title: 'Total Payables',
            data: detail,
            accentColor: AppColors.accent,
          ),

          SizedBox(height: Dimensions.height20),

          // ── Overdue split ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Overdue Split by days',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height15),

          OverdueSplitGrid(split: detail.overdueSplit),

          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }
}
