// Shared helpers used by both receivables and payables sheets.
import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class FinancialSummary {
  final double total;
  final double current;
  final double overdue;
  final List<double> split; // [1-15, 16-30, 31-45, >45]

  const FinancialSummary({
    required this.total,
    required this.current,
    required this.overdue,
    required this.split,
  });
}

// ── Sheet drag handle ─────────────────────────────────────────────────────────
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width20 * 2,
      height: Dimensions.height10 * 0.4,
      margin: EdgeInsets.symmetric(vertical: Dimensions.height10),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
    );
  }
}

// ── Summary card (amount + progress bar + current/overdue row) ────────────────
class FinancialSummaryCard extends StatelessWidget {
  final String title;
  final FinancialSummary data;
  final Color accentColor;

  const FinancialSummaryCard({
    super.key,
    required this.title,
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
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
              '₹${_fmt(data.total)}',
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
                value: data.total == 0
                    ? 0
                    : (data.overdue / data.total).clamp(0.0, 1.0),
                minHeight: Dimensions.height10 * 0.4,
                backgroundColor: Appcolors.ok.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(
                  data.overdue > 0 ? Appcolors.warning : Appcolors.ok,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height15),
            Row(
              children: [
                SummaryLabel(
                  label: 'Current',
                  value: '₹${_fmt(data.current)}',
                  color: accentColor,
                ),
                SizedBox(width: Dimensions.width30),
                SummaryLabel(
                  label: 'Overdue',
                  value: '₹${_fmt(data.overdue)}',
                  color: Appcolors.warn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(2);
}

// ── Overdue split grid ─────────────────────────────────────────────────────────
class OverdueSplitGrid extends StatelessWidget {
  final List<double> split;

  static const _labels = ['1–15 Days', '16–30 Days', '31–45 Days', '> 45 Days'];

  const OverdueSplitGrid({super.key, required this.split});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
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
                _labels[i],
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.75,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: Dimensions.height10 / 3),
              Text(
                '₹${split[i].toStringAsFixed(2)}',
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
