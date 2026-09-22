import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/core/widgets/bottom_sheet_drag_handle.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:custom_books/features/home/widgets/financial_summary_sheet_helpers.dart';
import 'package:flutter/material.dart';

void showReceivablesSheet(BuildContext context, FinancialDetail detail) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ReceivablesSheet(detail: detail),
  );
}

class ReceivablesSheet extends StatelessWidget {
  final FinancialDetail detail;

  const ReceivablesSheet({super.key, required this.detail});

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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_received_rounded,
                    color: AppColors.primary,
                    size: Dimensions.iconSize22,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Total Receivables',
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

          FinancialSummaryCard(
            title: 'Total Receivables',
            data: detail,
            accentColor: AppColors.primary,
          ),

          SizedBox(height: Dimensions.height20),

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
