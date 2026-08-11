import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:custom_books/features/home/models/income_expense_point_model.dart';
import 'package:custom_books/features/home/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';

enum FiscalPeriod {
  thisFiscalYear('This Fiscal Year'),
  previousFiscalYear('Previous Fiscal Year'),
  last12Months('Last 12 Months'),
  last6Months('Last 6 Months');

  final String label;
  const FiscalPeriod(this.label);
}

class IncomeExpenseCardWidget extends StatefulWidget {
  const IncomeExpenseCardWidget({super.key});

  @override
  State<IncomeExpenseCardWidget> createState() =>
      _IncomeExpenseCardWidgetState();
}

class _IncomeExpenseCardWidgetState extends State<IncomeExpenseCardWidget> {
  bool _isAccrual = true;
  FiscalPeriod _selectedPeriod = FiscalPeriod.thisFiscalYear;
  int? _touchedBarIndex;
  bool _touchedIsIncome = true;

  List<IncomeExpensePoint> get _filteredData {
    switch (_selectedPeriod) {
      case FiscalPeriod.thisFiscalYear:
      case FiscalPeriod.previousFiscalYear:
      case FiscalPeriod.last12Months:
        return incomeExpenseData;
      case FiscalPeriod.last6Months:
        return incomeExpenseData.sublist(6);
    }
  }

  void _showPeriodPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: Dimensions.height10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.textTertiary.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: Dimensions.height10),
              ...FiscalPeriod.values.map(
                (period) => ListTile(
                  title: Text(
                    period.label,
                    style: TextStyle(
                      fontWeight: period == _selectedPeriod
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: period == _selectedPeriod
                          ? Appcolors.primary
                          : context.colors.textPrimary,
                    ),
                  ),
                  onTap: () {
                    setState(() => _selectedPeriod = period);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              SizedBox(height: Dimensions.height10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _filteredData;
    final totalIncome = data.fold<double>(0, (p, e) => p + e.income);
    final totalExpense = data.fold<double>(0, (p, e) => p + e.expense);

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
          // Header row: title + fiscal year dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardTitle(
                title: 'Income and Expense',
                icon: Icons.pie_chart_outline_rounded,
              ),
              GestureDetector(
                onTap: _showPeriodPicker,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 * 0.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedPeriod.label,
                        style: TextStyle(
                          fontSize: Dimensions.font16 * 0.75,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textPrimary,
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
          SizedBox(height: Dimensions.height15),

          // Accrual / Cash segmented toggle
          _AccrualCashToggle(
            isAccrual: _isAccrual,
            onChanged: (val) => setState(() => _isAccrual = val),
          ),
          SizedBox(height: Dimensions.height20),

          // Bar chart with Y-axis labels
          SizedBox(
            height: Dimensions.screenHeight / 3.2,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    _handleBarTap(
                      details.localPosition,
                      constraints.biggest,
                      data,
                    );
                  },
                  onTapUp: (_) {
                    // Keep tooltip visible briefly
                  },
                  child: CustomPaint(
                    size: constraints.biggest,
                    painter: _IncomeExpenseBarPainter(
                      data: data,
                      incomeColor: Appcolors.info,
                      expenseColor: const Color(0xFFF5A623),
                      gridColor: context.colors.border,
                      labelColor: context.colors.textTertiary,
                      touchedIndex: _touchedBarIndex,
                      touchedIsIncome: _touchedIsIncome,
                      tooltipBgColor: context.colors.card,
                      tooltipTextColor: context.colors.textSecondary,
                      tooltipBorderColor: context.colors.border,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // Bottom summary: Income + Expense totals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TotalLabel(
                label: 'Income',
                value: totalIncome,
                color: Appcolors.info,
              ),
              _TotalLabel(
                label: 'Expense',
                value: totalExpense,
                color: const Color(0xFFF5A623),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBarTap(
    Offset position,
    Size size,
    List<IncomeExpensePoint> data,
  ) {
    const leftPadding = 45.0;
    final chartWidth = size.width - leftPadding;
    final groupWidth = chartWidth / data.length;

    final xInChart = position.dx - leftPadding;
    if (xInChart < 0) return;

    final index = (xInChart / groupWidth).floor();
    if (index < 0 || index >= data.length) return;

    setState(() {
      if (_touchedBarIndex == index) {
        _touchedBarIndex = null;
      } else {
        _touchedBarIndex = index;
        final localX = xInChart - (groupWidth * index);
        _touchedIsIncome = localX < groupWidth / 2;
      }
    });
  }
}

// -------- Accrual / Cash Toggle --------
class _AccrualCashToggle extends StatelessWidget {
  final bool isAccrual;
  final ValueChanged<bool> onChanged;

  const _AccrualCashToggle({required this.isAccrual, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            label: 'Accrual',
            isSelected: isAccrual,
            onTap: () => onChanged(true),
          ),
          _ToggleItem(
            label: 'Cash',
            isSelected: !isAccrual,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width15,
          vertical: Dimensions.height10 * 0.6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          border: isSelected
              ? Border.all(
                  color: context.colors.textPrimary.withValues(alpha: 0.6),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.85,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? context.colors.textPrimary
                : context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// -------- Total Label Widget --------
class _TotalLabel extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _TotalLabel({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.9,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        SizedBox(height: Dimensions.height10 * 0.3),
        Text(
          'AED${_formatAmount(value)}',
          style: TextStyle(
            fontSize: Dimensions.font16 * 1.3,
            fontWeight: FontWeight.w800,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      final formatted = amount.toStringAsFixed(2);
      final parts = formatted.split('.');
      final intPart = parts[0];
      final decPart = parts[1];
      final buffer = StringBuffer();
      int count = 0;
      for (int i = intPart.length - 1; i >= 0; i--) {
        buffer.write(intPart[i]);
        count++;
        if (count % 3 == 0 && i != 0) buffer.write(',');
      }
      return '${buffer.toString().split('').reversed.join()}.$decPart';
    }
    return amount.toStringAsFixed(2);
  }
}

// -------- Custom Bar Chart Painter --------
class _IncomeExpenseBarPainter extends CustomPainter {
  final List<IncomeExpensePoint> data;
  final Color incomeColor;
  final Color expenseColor;
  final Color gridColor;
  final Color labelColor;
  final int? touchedIndex;
  final bool touchedIsIncome;
  final Color tooltipBgColor;
  final Color tooltipTextColor;
  final Color tooltipBorderColor;

  _IncomeExpenseBarPainter({
    required this.data,
    required this.incomeColor,
    required this.expenseColor,
    required this.gridColor,
    required this.labelColor,
    this.touchedIndex,
    this.touchedIsIncome = true,
    required this.tooltipBgColor,
    required this.tooltipTextColor,
    required this.tooltipBorderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 45.0;
    const bottomPadding = 24.0;
    const topPadding = 10.0;

    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding - topPadding;

    // Find max value for scaling
    double maxVal = 0;
    for (final point in data) {
      if (point.income > maxVal) maxVal = point.income;
      if (point.expense > maxVal) maxVal = point.expense;
    }
    if (maxVal == 0) maxVal = 1;

    // Calculate nice Y-axis intervals
    final ySteps = _calculateYSteps(maxVal);
    final adjustedMax = ySteps.last;

    // Draw horizontal grid lines and Y-axis labels
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (final step in ySteps) {
      final y = topPadding + chartHeight - (step / adjustedMax) * chartHeight;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      // Y-axis label
      final labelText = _formatYLabel(step);
      final tp = TextPainter(
        text: TextSpan(
          text: labelText,
          style: TextStyle(fontSize: 10, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftPadding - tp.width - 6, y - tp.height / 2));
    }

    // Draw bars
    final groupWidth = chartWidth / data.length;
    final barWidth = groupWidth * 0.3;
    const radius = Radius.circular(3);

    final incomePaint = Paint()..color = incomeColor;
    final expensePaint = Paint()..color = expenseColor;

    for (int i = 0; i < data.length; i++) {
      final centerX = leftPadding + groupWidth * i + groupWidth / 2;

      // Income bar
      final incomeHeight = (data[i].income / adjustedMax) * chartHeight;
      if (incomeHeight > 0) {
        final incomeRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(
            centerX - barWidth - 1.5,
            topPadding + chartHeight - incomeHeight,
            barWidth,
            incomeHeight,
          ),
          topLeft: radius,
          topRight: radius,
        );
        canvas.drawRRect(incomeRect, incomePaint);
      }

      // Expense bar
      final expenseHeight = (data[i].expense / adjustedMax) * chartHeight;
      if (expenseHeight > 0) {
        final expenseRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(
            centerX + 1.5,
            topPadding + chartHeight - expenseHeight,
            barWidth,
            expenseHeight,
          ),
          topLeft: radius,
          topRight: radius,
        );
        canvas.drawRRect(expenseRect, expensePaint);
      }

      // X-axis month labels
      final monthTp = TextPainter(
        text: TextSpan(
          text: data[i].month,
          style: TextStyle(fontSize: 10, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthTp.paint(
        canvas,
        Offset(centerX - monthTp.width / 2, topPadding + chartHeight + 6),
      );
    }

    // Draw tooltip for touched bar
    if (touchedIndex != null &&
        touchedIndex! >= 0 &&
        touchedIndex! < data.length) {
      final point = data[touchedIndex!];
      final value = touchedIsIncome ? point.income : point.expense;
      final centerX = leftPadding + groupWidth * touchedIndex! + groupWidth / 2;
      final barHeight = (value / adjustedMax) * chartHeight;
      final barTop = topPadding + chartHeight - barHeight;

      final tooltipText = 'AED${value.toStringAsFixed(0)}';
      final monthText = '${point.month} 2026';

      final tp1 = TextPainter(
        text: TextSpan(
          text: tooltipText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: tooltipTextColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final tp2 = TextPainter(
        text: TextSpan(
          text: monthText,
          style: TextStyle(fontSize: 10, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final tooltipWidth = (tp1.width > tp2.width ? tp1.width : tp2.width) + 16;
      final tooltipHeight = tp1.height + tp2.height + 12;

      var tooltipX = centerX - tooltipWidth / 2;
      var tooltipY = barTop - tooltipHeight - 10;
      if (tooltipY < 0) tooltipY = barTop + 5;
      if (tooltipX < leftPadding) tooltipX = leftPadding;
      if (tooltipX + tooltipWidth > size.width) {
        tooltipX = size.width - tooltipWidth;
      }

      final tooltipRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
        const Radius.circular(6),
      );

      // Shadow
      canvas.drawRRect(
        tooltipRect.shift(const Offset(0, 2)),
        Paint()..color = tooltipBorderColor.withValues(alpha: 0.3),
      );

      // Background
      canvas.drawRRect(tooltipRect, Paint()..color = tooltipBgColor);

      // Border
      canvas.drawRRect(
        tooltipRect,
        Paint()
          ..color = tooltipBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );

      tp1.paint(canvas, Offset(tooltipX + 8, tooltipY + 4));
      tp2.paint(canvas, Offset(tooltipX + 8, tooltipY + 4 + tp1.height + 2));

      // Arrow/triangle pointing down
      final arrowPath = Path()
        ..moveTo(centerX - 5, tooltipY + tooltipHeight)
        ..lineTo(centerX, tooltipY + tooltipHeight + 5)
        ..lineTo(centerX + 5, tooltipY + tooltipHeight)
        ..close();
      canvas.drawPath(arrowPath, Paint()..color = tooltipBgColor);
      canvas.drawPath(
        arrowPath,
        Paint()
          ..color = tooltipBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }
  }

  List<double> _calculateYSteps(double maxVal) {
    // Determine nice round intervals
    final rawInterval = maxVal / 5;
    double interval;

    if (rawInterval <= 100) {
      interval = 200;
    } else if (rawInterval <= 200) {
      interval = 400;
    } else if (rawInterval <= 500) {
      interval = 500;
    } else if (rawInterval <= 1000) {
      interval = 1000;
    } else if (rawInterval <= 2000) {
      interval = 2000;
    } else {
      interval = (rawInterval / 1000).ceil() * 1000;
    }

    final steps = <double>[0];
    double current = interval;
    while (current <= maxVal * 1.1) {
      steps.add(current);
      current += interval;
    }
    if (steps.last < maxVal) {
      steps.add(current);
    }
    return steps;
  }

  String _formatYLabel(double value) {
    if (value == 0) return '0';
    if (value >= 1000) {
      final k = value / 1000;
      if (k == k.roundToDouble()) {
        return '${k.toInt()}K';
      }
      return '${k.toStringAsFixed(1)}K';
    }
    return value.toInt().toString();
  }

  @override
  bool shouldRepaint(covariant _IncomeExpenseBarPainter oldDelegate) {
    return oldDelegate.touchedIndex != touchedIndex ||
        oldDelegate.touchedIsIncome != touchedIsIncome ||
        oldDelegate.data != data;
  }
}
