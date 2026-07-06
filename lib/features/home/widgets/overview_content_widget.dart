import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:flutter/material.dart';

// -------- Card Title Widget --------
class CardTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const CardTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.iconSize16, color: Appcolors.primary),
        SizedBox(width: Dimensions.width10 / 2),
        Text(
          title,
          style: TextStyle(
            fontSize: Dimensions.font16 * 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// -------- Income & Expense Card Widget --------
class IncomeExpenseCard extends StatefulWidget {
  const IncomeExpenseCard({super.key});

  @override
  State<IncomeExpenseCard> createState() => _IncomeExpenseCardState();
}

class _IncomeExpenseCardState extends State<IncomeExpenseCard> {
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                      color: Colors.black38,
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
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'AED${value.toStringAsFixed(2)}',
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

// -------- Project Timer Card Widget --------
class ProjectTimerCard extends StatelessWidget {
  const ProjectTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Timer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: Dimensions.font16 * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.schedule_rounded,
                color: Appcolors.primaryLight,
                size: Dimensions.iconSize16,
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            '00:00:00',
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font26 * 1.3,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              Expanded(
                child: OutlineChip(label: 'Log Time', color: Colors.white),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: FilledChip(
                  label: 'Start Timer',
                  color: Appcolors.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Row(
            children: [
              Expanded(
                child: StatChip(label: 'Unbilled Hours', value: '00:00'),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: StatChip(label: 'Unbilled Expenses', value: 'AED0.00'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -------- Outline Chip Widget --------
class OutlineChip extends StatelessWidget {
  final String label;
  final Color color;

  const OutlineChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -------- Filled Chip Widget --------
class FilledChip extends StatelessWidget {
  final String label;
  final Color color;

  const FilledChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: Dimensions.font16 * 0.85,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -------- Stat Chip Widget --------
class StatChip extends StatelessWidget {
  final String label;
  final String value;

  const StatChip({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: Dimensions.font16 * 0.65,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// -------- Expense Breakdown Card Widget --------
class ExpenseBreakdownCard extends StatelessWidget {
  const ExpenseBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final total = topExpenses.fold<double>(0, (p, e) => p + e.amount);
    return Container(
      padding: EdgeInsets.all(Dimensions.width15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardTitle(
                title: 'Expense Breakdown',
                icon: Icons.donut_small_rounded,
              ),
              Text(
                'AED${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w800,
                  color: Appcolors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height20),
          ...topExpenses.map((e) {
            final ratio = total == 0 ? 0.0 : (e.amount / total).clamp(0.0, 1.0);
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
                        'AED${e.amount.toStringAsFixed(2)}',
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
                      Dimensions.radius15 - 5,
                    ),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2E8F0),
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
