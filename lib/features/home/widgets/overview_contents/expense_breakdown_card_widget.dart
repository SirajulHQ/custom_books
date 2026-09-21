import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/features/home/models/expense_item_model.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';

class ExpenseBreakdownCardWidget extends StatefulWidget {
  const ExpenseBreakdownCardWidget({super.key});

  @override
  State<ExpenseBreakdownCardWidget> createState() =>
      _ExpenseBreakdownCardWidgetState();
}

class _ExpenseBreakdownCardWidgetState
    extends State<ExpenseBreakdownCardWidget> {
  String _selectedPeriod = 'This Fiscal Year';

  // Sample data — replace with real expense data when the backend is wired up.
  static final List<ExpenseItem> _topExpenses = [
    ExpenseItem('Salaries & Wages', 8500, 45.5, const Color(0xFF3B82F6)),
    ExpenseItem('Rent & Utilities', 3200, 17.1, const Color(0xFF8B5CF6)),
    ExpenseItem('Marketing', 2800, 15.0, const Color(0xFF10B981)),
    ExpenseItem('Supplies', 2100, 11.2, const Color(0xFFF59E0B)),
    ExpenseItem('Insurance', 1500, 8.0, const Color(0xFFEF4444)),
    ExpenseItem('Other', 600, 3.2, const Color(0xFF94A3B8)),
  ];

  void _showPeriodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExpenseBreakdownPeriodSheet(
        selectedPeriod: _selectedPeriod,
        onSelected: (period) {
          setState(() => _selectedPeriod = period);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _topExpenses.fold<double>(0, (p, e) => p + e.amount);
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header with title and period dropdown ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardTitle(
                title: 'Expense Breakdown',
                icon: Icons.donut_small_rounded,
              ),
              GestureDetector(
                onTap: _showPeriodSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 * 0.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedPeriod,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.72,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10 * 0.4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: Dimensions.iconSize16,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10 * 0.8),

          // ── Total expenses summary ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Expenses',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 0.82,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Dimensions.font16 * 1.05,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Divider(height: 1, color: context.colors.border),
          SizedBox(height: Dimensions.height10),
          ..._topExpenses.map((e) {
            final ratio =
                total == 0 ? 0.0 : (e.amount / total).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.height10 / 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${e.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.85,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height10 / 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius15 * 0.67,
                    ),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: Dimensions.height10 * 0.6,
                      backgroundColor: context.colors.border,
                      valueColor: AlwaysStoppedAnimation(e.color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ── Period Selection Bottom Sheet ─────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════════════════

class _ExpenseBreakdownPeriodSheet extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onSelected;

  const _ExpenseBreakdownPeriodSheet({
    required this.selectedPeriod,
    required this.onSelected,
  });

  static const _periods = [
    'This Fiscal Year',
    'Previous Fiscal Year',
    'Last 12 Months',
    'Last 6 Months',
  ];

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
          // ── Handle ──
          Center(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height15),
              width: Dimensions.width20 * 2,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // ── Options list ──
          ...List.generate(_periods.length, (i) {
            final period = _periods[i];
            final isSelected = period == selectedPeriod;
            return GestureDetector(
              onTap: () => onSelected(period),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width20,
                  vertical: Dimensions.height20,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i < _periods.length - 1
                          ? context.colors.border.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 1.1,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : context.colors.textPrimary,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }
}

