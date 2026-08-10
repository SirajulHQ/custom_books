import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:custom_books/dummy_data/dummy_data_list.dart';
import 'package:flutter/material.dart';

class CashFlowCardWidget extends StatelessWidget {
  const CashFlowCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final last = cashFlowData.last;
    final totalIncoming = incomeExpenseData.fold<double>(
      0,
      (p, e) => p + e.income,
    );
    final totalOutgoing = incomeExpenseData.fold<double>(
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
          _cardTitle('Cash Flow Trend', Icons.show_chart_rounded),
          SizedBox(height: Dimensions.height15),
          SizedBox(
            height: Dimensions.screenHeight / 5,
            width: double.infinity,
            child: CustomPaint(
              painter: _AreaChartPainter(
                values: cashFlowData.map((e) => e.ending).toList(),
                color: Appcolors.accent,
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cashFlowData
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
          Divider(height: Dimensions.height30, color: context.colors.border),
          _statLine(
            context,
            'Opening (01 Jan 2026)',
            '₹0.00',
            context.colors.textSecondary,
          ),
          _statLine(
            context,
            'Money In',
            '₹${totalIncoming.toStringAsFixed(2)}',
            Appcolors.ok,
          ),
          _statLine(
            context,
            'Money Out',
            '₹${totalOutgoing.toStringAsFixed(2)}',
            Appcolors.warn,
          ),
          _statLine(
            context,
            'Closing (31 Dec 2026)',
            '₹${last.ending.toStringAsFixed(2)}',
            Appcolors.accent,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _statLine(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool bold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10 / 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.85,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.font16,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTitle(String title, IconData icon) {
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

class _AreaChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  _AreaChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = values
        .reduce((a, b) => a > b ? a : b)
        .clamp(1, double.infinity);
    final stepX = size.width / (values.length - 1);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = color;
    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
