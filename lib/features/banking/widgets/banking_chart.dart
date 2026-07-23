import 'package:custom_books/core/apptheme/apptheme.dart';
import 'package:custom_books/core/utils/dimensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankingChart extends StatefulWidget {
  final List<FlSpot> dataPoints;
  final double cashInHand;
  final double bankBalance;

  const BankingChart({
    super.key,
    required this.dataPoints,
    required this.cashInHand,
    required this.bankBalance,
  });

  @override
  State<BankingChart> createState() => _BankingChartState();
}

class _BankingChartState extends State<BankingChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: EdgeInsets.fromLTRB(
        Dimensions.width10,
        Dimensions.height10,
        Dimensions.width20,
        Dimensions.height20,
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white,
              tooltipRoundedRadius: Dimensions.radius15 * 0.7,
              tooltipPadding: EdgeInsets.all(Dimensions.width15 * 0.7),
              tooltipBorder: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1,
              ),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final date = DateTime(
                    2024,
                    6,
                    23,
                  ).add(Duration(days: barSpot.x.toInt()));
                  return LineTooltipItem(
                    '${DateFormat('dd MMM').format(date)}\n',
                    TextStyle(
                      color: Appcolors.textPrimary,
                      fontSize: Dimensions.font16 * 0.7,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: 'Cash In Hand\n',
                        style: TextStyle(
                          color: Appcolors.textSecondary,
                          fontSize: Dimensions.font16 * 0.65,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '₹${widget.cashInHand.toStringAsFixed(2)}\n',
                        style: TextStyle(
                          color: Appcolors.textPrimary,
                          fontSize: Dimensions.font16 * 0.7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'Bank Balance\n',
                        style: TextStyle(
                          color: Appcolors.success,
                          fontSize: Dimensions.font16 * 0.65,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '₹${widget.bankBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Appcolors.success,
                          fontSize: Dimensions.font16 * 0.7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 5,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final date = DateTime(
                    2024,
                    6,
                    23,
                  ).add(Duration(days: value.toInt()));
                  return Padding(
                    padding: EdgeInsets.only(top: Dimensions.height10 / 2),
                    child: Text(
                      DateFormat('dd MMM').format(date),
                      style: TextStyle(
                        color: Appcolors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.font16 * 0.65,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1000,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Padding(
                    padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                    child: Text(
                      '${(value / 1000).toStringAsFixed(0)}K',
                      style: TextStyle(
                        color: Appcolors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimensions.font16 * 0.65,
                      ),
                    ),
                  );
                },
                reservedSize: 36,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 29,
          minY: 0,
          maxY: 7000,
          lineBarsData: [
            LineChartBarData(
              spots: widget.dataPoints,
              isCurved: true,
              gradient: LinearGradient(
                colors: [Appcolors.success.withValues(alpha: 0.9), Appcolors.success],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Appcolors.success.withValues(alpha: 0.12),
                    Appcolors.success.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
