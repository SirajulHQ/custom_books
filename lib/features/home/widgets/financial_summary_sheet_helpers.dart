// Shared helpers used by both receivables and payables sheets.
import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/dashboard_overview_model.dart';
import 'package:flutter/material.dart';

double _toDouble(String v) => double.tryParse(v.replaceAll(',', '')) ?? 0.0;

// ── Summary card (amount + progress bar + current/overdue row) ────────────────
class FinancialSummaryCard extends StatelessWidget {
  final String title;
  final FinancialDetail data;
  final Color accentColor;

  const FinancialSummaryCard({
    super.key,
    required this.title,
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final total = _toDouble(data.total);
    final overdue = _toDouble(data.overdue);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.width20),
        decoration: BoxDecoration(
          color: context.colors.surfaceLight,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: Dimensions.font16 * 0.85,
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Dimensions.height10 / 2),
            Text(
              data.totalDisplay,
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.27),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : (overdue / total).clamp(0.0, 1.0),
                minHeight: Dimensions.height10 * 0.4,
                backgroundColor: AppColors.ok.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(
                  overdue > 0 ? AppColors.warning : AppColors.ok,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                SummaryLabel(
                  label: 'Current',
                  value: data.currentDisplay,
                  color: accentColor,
                ),
                SizedBox(width: Dimensions.width30),
                SummaryLabel(
                  label: 'Overdue',
                  value: data.overdueDisplay,
                  color: AppColors.warn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Overdue split grid ─────────────────────────────────────────────────────────
class OverdueSplitGrid extends StatelessWidget {
  final List<OverdueBucket> split;

  const OverdueSplitGrid({super.key, required this.split});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: split.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: Dimensions.height10,
          crossAxisSpacing: Dimensions.width10,
          childAspectRatio: 2.4,
        ),
        itemBuilder: (_, i) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width15,
            vertical: Dimensions.height10,
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceLight,
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                split[i].label,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 3),
              Text(
                split[i].amountDisplay,
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.95,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Label + value column ──────────────────────────────────────────────────────
class SummaryLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const SummaryLabel({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 3),
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.95,
            fontWeight: FontWeight.w700,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
