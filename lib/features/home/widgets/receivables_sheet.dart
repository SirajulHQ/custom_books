import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/widgets/financial_summary_sheet_helpers.dart';
import 'package:flutter/material.dart';

void showReceivablesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ReceivablesSheet(),
  );
}

class ReceivablesSheet extends StatelessWidget {
  const ReceivablesSheet({super.key});

  // Replace with real data source when ready
  static const _data = FinancialSummary(
    total: 5886.00,
    current: 0.00,
    overdue: 5886.00,
    split: [0.00, 0.00, 5886.00, 0.00],
  );

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),

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
                    color: Appcolors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.call_received_rounded,
                    color: Appcolors.primary,
                    size: Dimensions.iconSize24 - 2,
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

          // ── Summary card ───────────────────────────────────────────────
          FinancialSummaryCard(
            title: 'Total Receivables',
            data: _data,
            accentColor: Appcolors.primary,
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

          OverdueSplitGrid(split: _data.split),

          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }
}
