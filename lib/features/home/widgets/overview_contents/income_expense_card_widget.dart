import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';

class IncomeExpenseCardWidget extends StatefulWidget {
  const IncomeExpenseCardWidget({super.key});

  @override
  State<IncomeExpenseCardWidget> createState() => _IncomeExpenseCardWidgetState();
}

class _IncomeExpenseCardWidgetState extends State<IncomeExpenseCardWidget> {
  bool _isAccrual = true;

  @override
  Widget build(BuildContext context) {
    final totalIncome = incomeExpenseData.fold<double>(
      0,
      (p, e) => p + e.income,
    );
    final totalExpense = incomeExpenseData.fold<double>(
      0,
      (p, e) => p + e.expense,
    );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardTitle(
                title: 'Income vs Expense',
                icon: Icons.stacked_bar_chart_rounded,
              ),
              GestureDetector(
                onTap: () => setState(() => _isAccrual = !_isAccrual),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  child: Text(
                    _isAccrual ? 'Accrual' : 'Cash',
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.75,
                      fontWeight: FontWeight.w700,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: MiniStat(
                  label: 'Income',
                  value: totalIncome,
                  color: Appcolors.ok,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: MiniStat(
                  label: 'Expense',
                  value: totalExpense,
                  color: Appcolors.warn,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          SizedBox(
            height: Dimensions.screenHeight / 3.5,
            width: double.infinity,
            child: CustomPaint(
              painter: _GroupedBarPainter(
                data: incomeExpenseData,
                colorA: Appcolors.ok,
                colorB: Appcolors.warn,
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: incomeExpenseData
                .map(
                  (e) => Text(
                    e.month,
                    style: TextStyle(
                      fontSize: Dimensions.font16 * 0.65,
                      color: context.colors.textTertiary,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// -------- Mini Stat Widget --------
class MiniStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: Dimensions.iconSize16),
          SizedBox(width: Dimensions.width10 / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.7,
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  '₹${value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.95,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Custom Painters ----------------

class _GroupedBarPainter extends CustomPainter {
  final List<IncomeExpensePoint> data;
  final Color colorA;
  final Color colorB;
  _GroupedBarPainter({
    required this.data,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data
        .map((e) => e.income > e.expense ? e.income : e.expense)
        .reduce((a, b) => a > b ? a : b)
        .clamp(1, double.infinity);

    final groupWidth = size.width / data.length;
    final barWidth = groupWidth * 0.28;
    const radius = Radius.circular(4);

    final paintA = Paint()..color = colorA;
    final paintB = Paint()..color = colorB;

    for (int i = 0; i < data.length; i++) {
      final centerX = groupWidth * i + groupWidth / 2;

      final aHeight = (data[i].income / maxVal) * size.height;
      final aRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          centerX - barWidth - 2,
          size.height - aHeight,
          barWidth,
          aHeight,
        ),
        topLeft: radius,
        topRight: radius,
      );
      canvas.drawRRect(aRect, paintA);

      final bHeight = (data[i].expense / maxVal) * size.height;
      final bRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(centerX + 2, size.height - bHeight, barWidth, bHeight),
        topLeft: radius,
        topRight: radius,
      );
      canvas.drawRRect(bRect, paintB);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
